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
128-frame processing blocks, and input/output metering. Open **Guitar Pedal**
from the desktop to launch the C engine and fullscreen native controls. The
launcher restores the saved pedal chain; closing its UI stops the engine it
started. Launching is manual, with no pedal boot service enabled.

The engine processes mono audio. ALSA's `plughw` conversion handles the board's
stereo hardware stream. The configured runtime was checked with both hardware
directions open at 48000 Hz, S16_LE, two channels, 128-frame hardware periods,
and 512-frame hardware buffers.

Runtime logs: `/home/pi/.cache/ml-guitar-pedal/launcher.log`.
Launcher backup: `/home/pi/project2/run-pedal.sh.before-adac-20261111-103502`.

## Mixer baseline

The configured baseline uses single-ended VINL1/VINR1 capture, ADC gain 0 dB,
microphone bias off, and DAC digital volume -30 dB, unmuted. Settings were saved
with `sudo alsactl store`.

```sh
amixer -c sndrpihifiberry sset 'ADC Mic Bias' 'Mic Bias off'
amixer -c sndrpihifiberry sset ADC 0dB
amixer -c sndrpihifiberry -- sset Digital -30dB unmute
sudo alsactl store
```

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
