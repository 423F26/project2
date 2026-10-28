# Add LV2 plugins to the pedal library

The [LV2 plugins ultimate list](https://github.com/alex-tee/lv2-plugins-ultimate-list) is a catalog of **plugin projects**, not a package of plugins. Browse its Distortion, Delay, Reverb, and Effect Packs sections for guitar effects, then follow the chosen project's installation instructions. The plugin must be installed on the Raspberry Pi or other Linux machine that runs `pedal effect`; installing it on the computer showing the browser UI will not make it available to the Pi.

## 1. Install the plugin and LV2 host library

On Debian or Raspberry Pi OS, install the native engine's build dependencies:

```bash
sudo apt update
sudo apt install cmake build-essential pkg-config libasound2-dev liblilv-dev libjson-c-dev
cmake -S native_pedal -B build/native -DCMAKE_BUILD_TYPE=Release
cmake --build build/native -j
```

Install a plugin from your distribution's packages if available, or build it using the linked project's own instructions for your machine's CPU architecture. The result should be an LV2 bundle (a directory usually ending in `.lv2` and containing `manifest.ttl`). Standard Unix locations include `~/.lv2` for one user and `/usr/local/lib/lv2` or `/usr/lib/lv2` system-wide. Lilv also honors `LV2_PATH` for other locations. See the [LV2 bundle location specification](https://lv2plug.in/pages/filesystem-hierarchy-standard.html) and [Lilv discovery documentation](https://drobilla.net/docs/lilv/).

## 2. Find a compatible plugin URI

From this repository on the audio machine, run:

```bash
uv run pedal effect --list-lv2
```

Each line shows a plugin name and its **URI**. Copy the URI exactly; it identifies the plugin, while the bundle folder name does not. This app lists effects it can currently host: one mono audio input, one mono audio output, control ports, and no required host features. Some catalog entries are instruments, stereo effects, MIDI plugins, or effects that need LV2 extensions; those will not appear.

For example, if the Guitarix GxRat plugin is installed, a line may look like:

```text
GxRat    http://guitarix.sourceforge.net/plugins/gx_aclipper_#_aclipper_
```

This example URI works only when that plugin is installed and appears in your own list. Keep URIs in quotes when entering them in a shell, especially if they contain `#`.

## 3. Import an installed effect in the browser UI

Start the audio process with your actual ALSA device names, then start the browser controller in a second terminal on the **same machine**:

```bash
uv run pedal effect --input plughw:1,0 --output plughw:1,0
uv run pedal demo-ui
```

Use `uv run pedal effect --list-devices` if you need ALSA names. Open `http://127.0.0.1:8765` on that machine, or use the [SSH tunnel in the live effect guide](live-effect.md#browser-control-over-ssh). Open **Pedal library → Import effect**. The dialog lists compatible installed LV2 effects; search by name or URI and press **Import**. The plugin appears in the pedal library immediately. Add it to the active board, then use its cog to edit control ports. Importing a plugin does not turn it on in the signal path until you add it to the board.

If you installed a new bundle after opening **Import effect**, restart `pedal effect` to refresh Lilv's scan. The button discovers local bundles; it does not download from GitHub or install packages. The native LVGL screen currently displays built-in pedals, so use the browser UI for a chain containing LV2 effects.

## 4. Optional: load by URI at startup

You can also pass an exact URI when starting audio:

```bash
uv run pedal effect --input plughw:1,0 --output plughw:1,0 \
  --lv2 'http://guitarix.sourceforge.net/plugins/gx_aclipper_#_aclipper_'
```

Repeat `--lv2` to load several effects. The first loaded LV2 effect is named `lv2-1` in board commands, the second `lv2-2`, and so on. To add one to the active signal path from another terminal:

```bash
uv run pedal mode board overdrive,lv2-1,delay
```

The board supports up to 32 distinct active pedals. The `--lv2` option is optional when using **Import effect**.

## If the plugin is missing

- Check that the package actually installed an LV2 bundle for the audio machine's CPU architecture. A VST or standalone version alone will not appear.
- Check that the bundle is in a standard LV2 location or in `LV2_PATH` for the account running `pedal effect`. Restart the effect process after installing a new bundle.
- If the bundle is installed but `--list-lv2` omits it, the plugin likely needs stereo, MIDI, Atom, or another host feature this app does not support. Try another effect from the catalog.
- If audio breaks up after adding a plugin, try a larger `--block` such as 256 and check the `--meter` output. Plugin CPU cost and latency vary, so test the chain on the target Pi before playing live.
