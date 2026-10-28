"""Minimal Lilv host for installed mono LV2 audio effects with control ports.

Plugins that need host features or non-audio/control ports are intentionally excluded.
"""

from __future__ import annotations

import ctypes as ct
import ctypes.util
import math

import numpy as np

from ml_guitar_pedal.processing import _pcm16


CORE = "http://lv2plug.in/ns/lv2core#"


class Descriptor(ct.Structure):
    _fields_ = [("uri", ct.c_char_p), ("instantiate", ct.c_void_p),
                ("connect_port", ct.c_void_p), ("activate", ct.c_void_p),
                ("run", ct.c_void_p), ("deactivate", ct.c_void_p),
                ("cleanup", ct.c_void_p), ("extension_data", ct.c_void_p)]


class Instance(ct.Structure):
    _fields_ = [("descriptor", ct.POINTER(Descriptor)), ("handle", ct.c_void_p),
                ("pimpl", ct.c_void_p)]


CONNECT = ct.CFUNCTYPE(None, ct.c_void_p, ct.c_uint32, ct.c_void_p)
ACTIVATE = ct.CFUNCTYPE(None, ct.c_void_p)
RUN = ct.CFUNCTYPE(None, ct.c_void_p, ct.c_uint32)


def _api():
    path = ctypes.util.find_library("lilv-0")
    if not path:
        raise RuntimeError("liblilv-0 is required for LV2 plugins")
    lib = ct.CDLL(path)
    signatures = {
        "lilv_world_new": (ct.c_void_p, []),
        "lilv_world_load_all": (None, [ct.c_void_p]),
        "lilv_world_get_all_plugins": (ct.c_void_p, [ct.c_void_p]),
        "lilv_plugins_begin": (ct.c_void_p, [ct.c_void_p]),
        "lilv_plugins_get": (ct.c_void_p, [ct.c_void_p, ct.c_void_p]),
        "lilv_plugins_next": (ct.c_void_p, [ct.c_void_p, ct.c_void_p]),
        "lilv_plugins_is_end": (ct.c_bool, [ct.c_void_p, ct.c_void_p]),
        "lilv_plugins_get_by_uri": (ct.c_void_p, [ct.c_void_p, ct.c_void_p]),
        "lilv_new_uri": (ct.c_void_p, [ct.c_void_p, ct.c_char_p]),
        "lilv_node_free": (None, [ct.c_void_p]),
        "lilv_node_as_string": (ct.c_char_p, [ct.c_void_p]),
        "lilv_node_as_float": (ct.c_float, [ct.c_void_p]),
        "lilv_plugin_get_uri": (ct.c_void_p, [ct.c_void_p]),
        "lilv_plugin_get_name": (ct.c_void_p, [ct.c_void_p]),
        "lilv_plugin_get_required_features": (ct.c_void_p, [ct.c_void_p]),
        "lilv_nodes_size": (ct.c_uint, [ct.c_void_p]),
        "lilv_nodes_free": (None, [ct.c_void_p]),
        "lilv_plugin_get_num_ports": (ct.c_uint, [ct.c_void_p]),
        "lilv_plugin_get_port_by_index": (ct.c_void_p, [ct.c_void_p, ct.c_uint32]),
        "lilv_port_is_a": (ct.c_bool, [ct.c_void_p, ct.c_void_p, ct.c_void_p]),
        "lilv_port_get_symbol": (ct.c_void_p, [ct.c_void_p, ct.c_void_p]),
        "lilv_port_get_range": (None, [ct.c_void_p, ct.c_void_p, ct.POINTER(ct.c_void_p), ct.POINTER(ct.c_void_p), ct.POINTER(ct.c_void_p)]),
        "lilv_plugin_instantiate": (ct.c_void_p, [ct.c_void_p, ct.c_double, ct.c_void_p]),
        "lilv_instance_free": (None, [ct.c_void_p]),
        "lilv_world_free": (None, [ct.c_void_p]),
    }
    for name, (result, args) in signatures.items():
        func = getattr(lib, name)
        func.restype = result
        func.argtypes = args
    return lib


class LV2World:
    def __init__(self):
        self.lib = _api()
        self.world = self.lib.lilv_world_new()
        self.lib.lilv_world_load_all(self.world)
        self.plugins = self.lib.lilv_world_get_all_plugins(self.world)
        self.classes = {name: self.lib.lilv_new_uri(self.world, (CORE + name + "Port").encode())
                        for name in ("Audio", "Control", "Input", "Output")}

    def _string(self, node):
        return self.lib.lilv_node_as_string(node).decode() if node else ""

    def find(self, uri):
        node = self.lib.lilv_new_uri(self.world, uri.encode())
        try:
            return self.lib.lilv_plugins_get_by_uri(self.plugins, node)
        finally:
            self.lib.lilv_node_free(node)

    def describe(self, plugin):
        lib = self.lib
        required = lib.lilv_plugin_get_required_features(plugin)
        try:
            if required and lib.lilv_nodes_size(required):
                return None
        finally:
            if required:
                lib.lilv_nodes_free(required)
        inputs, outputs, controls, control_outputs = [], [], {}, []
        for index in range(lib.lilv_plugin_get_num_ports(plugin)):
            port = lib.lilv_plugin_get_port_by_index(plugin, index)
            is_a = lambda name: lib.lilv_port_is_a(plugin, port, self.classes[name])
            if is_a("Audio") and is_a("Input"):
                inputs.append(index)
            elif is_a("Audio") and is_a("Output"):
                outputs.append(index)
            elif is_a("Control"):
                symbol = self._string(lib.lilv_port_get_symbol(plugin, port))
                nodes = [ct.c_void_p() for _ in range(3)]
                lib.lilv_port_get_range(plugin, port, *(ct.byref(node) for node in nodes))
                values = [float(lib.lilv_node_as_float(node)) if node else None for node in nodes]
                for node in nodes:
                    if node:
                        lib.lilv_node_free(node)
                if is_a("Input"):
                    controls[symbol] = (index, *values)
                elif is_a("Output"):
                    control_outputs.append(index)
                else:
                    return None
            else:
                return None
        if len(inputs) != 1 or len(outputs) != 1:
            return None
        return inputs[0], outputs[0], controls, control_outputs

    def available(self):
        found = []
        iterator = self.lib.lilv_plugins_begin(self.plugins)
        while not self.lib.lilv_plugins_is_end(self.plugins, iterator):
            plugin = self.lib.lilv_plugins_get(self.plugins, iterator)
            if self.describe(plugin) is not None:
                found.append((self._string(self.lib.lilv_plugin_get_uri(plugin)),
                              self._string(self.lib.lilv_plugin_get_name(plugin))))
            iterator = self.lib.lilv_plugins_next(self.plugins, iterator)
        return found

    def close(self):
        if self.world:
            for node in self.classes.values():
                self.lib.lilv_node_free(node)
            self.lib.lilv_world_free(self.world)
            self.world = None


class LV2Processor:
    def __init__(self, world: LV2World, uri: str, sample_rate: int):
        self.world, self.uri, self.sample_rate = world, uri, sample_rate
        plugin = world.find(uri)
        if not plugin:
            raise ValueError(f"LV2 plugin is not installed: {uri}")
        description = world.describe(plugin)
        if description is None:
            raise ValueError(f"LV2 plugin requires unsupported ports or host features: {uri}")
        self.input_port, self.output_port, self.controls, self.control_outputs = description
        self.display_name = world._string(world.lib.lilv_plugin_get_name(plugin))
        self.settings = {}
        self._control_values = {}
        for symbol, (index, default, minimum, maximum) in self.controls.items():
            value = default if default is not None else (minimum if minimum is not None else 0.0)
            self.settings[symbol] = value
            self._control_values[index] = ct.c_float(value)
        for index in self.control_outputs:
            self._control_values[index] = ct.c_float()
        self.instance = world.lib.lilv_plugin_instantiate(plugin, sample_rate, None)
        if not self.instance:
            raise RuntimeError(f"could not instantiate LV2 plugin: {uri}")
        native = ct.cast(self.instance, ct.POINTER(Instance)).contents
        self._native = native
        self._connect = CONNECT(native.descriptor.contents.connect_port)
        self._run = RUN(native.descriptor.contents.run)
        for index, value in self._control_values.items():
            self._connect(native.handle, index, ct.byref(value))
        if native.descriptor.contents.activate:
            ACTIVATE(native.descriptor.contents.activate)(native.handle)

    def set_parameter(self, name: str, value: float):
        if name not in self.controls or not math.isfinite(value):
            raise ValueError("invalid LV2 control")
        index, _, minimum, maximum = self.controls[name]
        if (minimum is not None and value < minimum) or (maximum is not None and value > maximum):
            raise ValueError("LV2 control outside plugin range")
        self.settings[name] = value
        self._control_values[index].value = value

    def process(self, samples):
        source = np.ascontiguousarray(samples.astype(np.float32) / 32768.0)
        result = np.zeros(len(source), dtype=np.float32)
        self._connect(self._native.handle, self.input_port, source.ctypes.data)
        self._connect(self._native.handle, self.output_port, result.ctypes.data)
        self._run(self._native.handle, len(source))
        return _pcm16(result * 32767)

    def __deepcopy__(self, memo):
        clone = type(self)(self.world, self.uri, self.sample_rate)
        for name, value in self.settings.items():
            clone.set_parameter(name, value)
        return clone

    def __del__(self):
        instance = getattr(self, "instance", None)
        if instance:
            self.world.lib.lilv_instance_free(instance)
            self.instance = None
