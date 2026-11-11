# Live effect

The engine captures mono ALSA audio, processes the active serial pedal board in C, and plays the result through ALSA. Start with `pedal-engine --list-devices`, then run `pedal-engine --input DEVICE --output DEVICE`. The default sample rate is 48 kHz with a 128 frame block. Use `--rate` and `--block` to tune these values.

Run `pedal-web` from the project root to control the board in a browser at `http://127.0.0.1:8765`. Add pedals from the library, drag to reorder, use the settings button on a pedal, and set the clean/effect mix. The board expands as pedals are activated. The `pedalctl` command sends the same changes through the local Unix socket.

For a remote browser, forward the local port with `ssh -L 8765:127.0.0.1:8765 pi-host`. The web server serves only on loopback. The default engine socket is `/run/guitar-effect.sock`; set `PEDAL_CONTROL_SOCKET` in all processes to override it.

On the ADAC-equipped Pi, use **AUDIO** in the native UI or **Audio** in the browser
for hardware output level, output mute, and input gain. Levels are shown in dB
and save automatically for the next launch. This output level is separate from
the effect mix and individual pedal levels. The panel also shows the audio rate,
buffer sizes, and microphone-bias status. It disables hardware controls when
ADAC is unavailable. See the [ADAC setup guide](../../HW/piADAC/RASPBERRY_PI_SETUP.md)
for ranges and persistence details.

On Raspberry Pi hardware, `pedal-footswitch` watches GPIO 17 with `gpiomon` and toggles the pedal when pressed. Its default chip and line can be changed with `--chip` and `--line`.
