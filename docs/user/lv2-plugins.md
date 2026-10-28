# Install and import LV2 effects

The [LV2 plugins ultimate list](https://github.com/alex-tee/lv2-plugins-ultimate-list) is a directory of plugin projects, not a single plugin bundle. Choose a plugin there, follow its own install instructions, and install its `.lv2` bundle in a standard LV2 location such as `~/.lv2` or `/usr/lib/lv2`. The pedal discovers installed plugins through Lilv.

The engine accepts compatible mono in/mono out LV2 audio effects with supported control ports. To see what it found:

```sh
./build/release/pedal-engine --list-lv2
```

Start the engine and browser as described in the [README](../../README.md). Open **Pedal library → Import effect**, search the installed effects, and choose **Import**. The effect appears in the library. Add it to the board to hear it; use its settings control to change its LV2 control ports. You can also use `pedalctl lv2-list` and `pedalctl lv2-load URI` while the engine runs.

Plugin availability and compatibility vary by plugin. Restart the engine after installing a new bundle so Lilv scans it. Test a newly installed effect at a safe output level.
