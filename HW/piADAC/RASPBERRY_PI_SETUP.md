# Raspberry Pi setup for piADAC

Configured and checked on 2026-11-11: Raspberry Pi 3 Model B, Raspberry Pi OS
Debian 13, kernel `6.18.50+rpt-rpi-v8`.

## Hardware mapping

The current `piADAC.kicad_pcb` connects the PCM1863 ADC and PCM5242 DAC as follows:

| Signal | BCM GPIO | Physical header pin | Connection |
| --- | --- | --- | --- |
| I²C SDA | 2 | 3 | ADC SDA and DAC SDA |
| I²C SCL | 3 | 5 | ADC SCL and DAC SCL |
| I²S bit clock | 18 | 12 | DAC BCK output, ADC BCK input |
| I²S frame clock | 19 | 35 | DAC LRCK output, ADC LRCK input |
| I²S capture | 20 | 38 | ADC DOUT through R3 |
| I²S playback | 21 | 40 | DAC DIN through R19 |

The ADC's MS/AD and MD0 straps select I²C address `0x4a`. The DAC's MODE1 is
low, MODE2 is high, ADR2 is low, and ADR1 is high, selecting I²C address `0x4d`.
The 22.5792 MHz oscillator enable connects to **DAC** GPIO6, and the 24.576 MHz
oscillator enable connects to **DAC** GPIO3. These are chip-local GPIOs, not
Raspberry Pi GPIO6/3. Their outputs feed the shared ADC/DAC master clock through
R21/R22. This matches the HiFiBerry DAC+ADC Pro driver's clock selection.

Use the standard Pro overlay without its `slave` option: the DAC supplies BCK and
LRCK, and the Pi and ADC consume them. I²C controls the chips; I²S carries audio.
The HAT EEPROM on physical pins 27/28 is on a separate bus and does not need
programming for this setup.

## Installed configuration

The relevant settings in `/boot/firmware/config.txt` are:

```ini
dtparam=audio=off
dtoverlay=vc4-kms-v3d,noaudio

[all]
dtparam=i2c_arm=on
dtparam=i2c_arm_baudrate=100000
dtoverlay=hifiberry-dacplusadcpro
```

Keep the other existing boot settings. The overlay enables I²S and loads the
codec and sound-card modules; a separate `dtparam=i2s=on` is unnecessary.
`/etc/modules-load.d/piadac.conf` contains `i2c-dev` for the I²C device interface.

The sound card is `snd_rpi_hifiberry_dacplusadcpro`, with ALSA card ID
`sndrpihifiberry`. Use the stable device name for both directions:

```text
hw:CARD=sndrpihifiberry,DEV=0
```

`plughw:CARD=sndrpihifiberry,DEV=0` allows ALSA format conversion. For example,
the repository's C runtime can use:

```sh
./run-with-audio.sh --input plughw:CARD=sndrpihifiberry,DEV=0 \
  --output plughw:CARD=sndrpihifiberry,DEV=0
```

The previous `guitar-effect.service` still targets an iRig USB interface and is
disabled. Enabling the audio board does not start the pedal engine or GPIO
footswitch listener.

### Configured Pi desktop launcher

On the Pi, `/home/pi/project2/run-pedal.sh` explicitly selects
`plughw:CARD=sndrpihifiberry,DEV=0` for input and output, with 48000 Hz,
128-frame processing blocks, and input/output metering. Open **Riffline**
from the desktop to launch the C engine and fullscreen native controls. The
launcher restores the saved pedal chain; closing its UI saves the settings and
stops the engine it started. It incrementally rebuilds the engine, bundled octave
plugin, and native UI on each launch, so a source update takes effect on the next
launch.

Boot launch is installed for the `pi` desktop user with:

```sh
./scripts/install-pi-desktop.sh --autostart
```

This installs the shortcut in `~/Desktop/Riffline.desktop`, the applications
menu entry in `~/.local/share/applications/guitar-pedal.desktop`, and the login
entry in `~/.config/autostart/guitar-pedal.desktop`. All point at the same checkout's
`run-pedal.sh`. Raspberry Pi OS's labwc desktop runs XDG autostart entries; with
desktop automatic login configured, this starts the pedal after boot. The
launcher waits up to 30 seconds for ADAC and prevents duplicate instances.

The engine processes mono audio. ALSA's `plughw` conversion handles the board's
stereo hardware stream. The configured runtime was checked with both hardware
directions open at 48000 Hz, S16_LE, two channels, 128-frame hardware periods,
and 512-frame hardware buffers.

Runtime logs: `/home/pi/.cache/ml-guitar-pedal/launcher.log`.
Launcher backup: `/home/pi/.cache/ml-guitar-pedal/run-pedal.sh.before-adac-20261111-103502`.

## Mixer baseline

The configured baseline uses single-ended VINL1/VINR1 capture, ADC gain 0 dB,
microphone bias off, and DAC digital volume -12 dB, unmuted. Initial bring-up used
-30 dB; the level was raised for listening. System settings were saved
with `sudo alsactl store`.

```sh
amixer -c sndrpihifiberry sset 'ADC Mic Bias' 'Mic Bias off'
amixer -c sndrpihifiberry sset ADC 0dB
amixer -c sndrpihifiberry -- sset Digital -12dB unmute
sudo alsactl store
```

The native **AUDIO** button and browser **Audio** panel expose output level
(-60 to 0 dB), output mute, and ADC input gain (-12 to +32 dB). Rate, hardware
period/buffer sizes, input selection, and microphone-bias status are shown for
reference. These controls use ALSA's named mixer controls in the UI processes;
they do not perform mixer I/O on the engine's audio thread. Clock, VCOM, raw
register, and microphone-bias writes are not exposed.

Changes save to `~/.config/ml-guitar-pedal/audio.json` (or under
`$XDG_CONFIG_HOME`) and restore on each desktop/boot launch. `pedal-audio state`
prints the current interface settings; `pedal-audio restore` reapplies the saved
levels. Input gain precedes the effects; increase it only while watching for
clipping. Output level affects both output channels after processing.

Playback now starts after two periods/blocks rather than waiting for the whole
ring to fill. The ring retains capacity for scheduling jitter. At the default
48 kHz / 128 frame settings the playback start threshold is 256 frames (5.33 ms)
instead of 512 frames (10.67 ms). This is a buffering setting, not a measured
analogue round-trip latency. The enabled Octave effect separately reports 768
frames (16 ms) of algorithmic delay; its algorithm has been preserved.

The DAC's extra 24 dB gain option is not enabled. Do not use raw register writes,
force access to driver-owned I²C addresses, change the VCOM mode, or manually
drive the clock pins. The board ties DAC VCOM to ground and shares oscillator
outputs; these connections must remain consistent with its design.

## Verification performed

- Playback and capture both enumerate with `aplay -l` / `arecord -l`.
- The ADC at `1-004a` is bound to `pcm186x`; the DAC at `1-004d` to `pcm512x`.
- Live device-tree I²C1 clock frequency reads 100000 Hz.
- GPIO2/3 show SDA1/SCL1; GPIO18–21 show the PCM/I²S alternate functions.
- Simultaneous stereo `S32_LE` capture and silent playback completed successfully
  for three seconds at each of 48000 Hz and 44100 Hz. Playback was muted during
  the tests, and captured samples were discarded.
- A second reboot confirmed automatic sound-card detection, microphone bias off,
  ADC gain 0 dB, DAC volume -30 dB, and desktop automatic login.
- The installed desktop shortcut was launched successfully, and a further reboot
  confirmed the XDG autostart entry opens the current native UI and ADAC engine.
- Audio settings were exercised against the actual ADAC mixer through the HTTP
  API, including level, input gain, mute, rejected unsupported controls, and saved
  settings. The browser slider was checked against the physical mixer value.
- With the two-period startup threshold, runtime samples showed approximately
  4.8–7.4 ms of queued playback audio as scheduling and capture queue depth varied.
  These snapshots exclude converter and effect delay; the startup threshold is
  5.33 ms, not an analogue round-trip measurement.

These checks establish driver binding and digital streaming, not analogue
input/output quality, measured latency, or electrical validation of the assembled
board. No raw bus scans or manual register writes were used.

The kernel's dummy-regulator messages reflect the standard overlay's lack of
software-controlled supply definitions; this board has fixed hardware LDOs.

## Backups on the Pi

- Boot configuration: `/boot/firmware/config.txt.before-adac-20261111-102632`
- Previous mixer state: `/var/lib/alsa/asound.state.before-adac-20261111`

Restoring the boot configuration and rebooting removes the board overlay.

## References

- [HiFiBerry Linux configuration](https://www.hifiberry.com/docs/software/configuring-linux-3-18-x/)
- [Raspberry Pi Pro overlay source](https://github.com/raspberrypi/linux/blob/rpi-6.18.y/arch/arm/boot/dts/overlays/hifiberry-dacplusadcpro-overlay.dts)
- [Raspberry Pi Pro driver source](https://github.com/raspberrypi/linux/blob/rpi-6.18.y/sound/soc/bcm/hifiberry_dacplusadcpro.c)
- [TI PCM1863 datasheet](https://www.ti.com/lit/ds/symlink/pcm1863.pdf)
- [TI PCM5242 datasheet](https://www.ti.com/lit/ds/symlink/pcm5242.pdf)

## Background-noise investigation (2026-11-11)

A five-second, 48 kHz, stereo S32_LE capture directly from the ALSA hardware
device, with ADC gain at 0 dB and microphone bias off, measured:

| Channel | RMS (dBFS) | Peak (dBFS) | 60 Hz component (dBFS RMS) |
| --- | ---: | ---: | ---: |
| Left / guitar | -43.0 | -20.5 | -53.3 |
| Right | -93.2 | -74.7 | -131.6 |
| Stereo average | -49.0 | -26.5 | -59.4 |

The left input also contained a strong 180 Hz component (-58.5 dBFS). This
capture was not a controlled, strings-muted noise-floor measurement; handling
and playing can contribute to the broadband RMS/peak readings. The user reported
that the noise changes with the guitar volume knob, with the guitar connected
directly to the board. Input and output meters were alike with all active effects
bypassed. These observations point toward hum entering along the guitar/input
path, rather than noise generated by an effect. They do not distinguish pickup
interference, cable shielding, or grounding by themselves. The unused right input
was much quieter and was not the dominant noise source.

The PCM1863 has a typical input impedance of 20 kOhm per analogue input pin,
according to [TI's datasheet](https://www.ti.com/lit/ds/symlink/pcm1863.pdf).
The current board routes its input through passive components to the ADC; it
does not provide a high-impedance instrument buffer. For passive pickups, compare
with an existing buffered pedal or instrument preamp feeding this board. Also
compare the guitar volume at zero and normal playing volume, and another screened
instrument cable, before changing hardware. Keep the ADC below clipping.

A limiter reduces peaks, not the idle hum. No I2C register, microphone-bias, VCOM,
clock, or GPIO changes were made during this investigation.
