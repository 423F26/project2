# Physical dial and bypass button

Riffline supports one mechanical rotary encoder and a separate button on these
BCM GPIO numbers:

| Contact | BCM GPIO | Physical header pin |
| --- | ---: | ---: |
| Encoder A | 23 | 16 |
| Encoder B | 24 | 18 |
| Button signal | 25 | 22 |
| Encoder common and button's other terminal | Ground | For example, 6 |

The controller requests only GPIO23, GPIO24 and GPIO25 as **inputs with internal
pull-ups**. The contacts connect them to ground. A bare mechanical encoder needs
no supply connection. These pins are separate from the ADAC's GPIO2/3 I2C and
GPIO18–21 I2S signals. Raspberry Pi GPIO uses 3.3 V and is not 5 V tolerant; see
the [official GPIO documentation](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html).

## Assign a parameter

1. Add the pedal to the board and open its settings using the cog.
2. Tap **DIAL** beside the parameter you want to control. The selected button
   turns green. Assigning another parameter replaces the previous assignment.
3. Turn the physical encoder to change that parameter. The open settings panel
   updates live, and changes stay within the parameter's range.
4. Press the GPIO25 button to bypass or un-bypass the **assigned pedal**. It
   does not toggle the whole board or change the assignment. A held press does
   not repeat.

**CLEAR DIAL** removes the assignment. An unassigned dial/button does not change
any pedal. The library heading shows the current assignment; the settings footer
also shows whether the controller is offline or the assigned pedal is bypassed.
An assigned pedal outside the active board can still have its settings changed,
but it must be on the board to affect the sound.

The browser settings panel has the same **Dial** and **Clear dial** controls,
including for imported LV2 effects. Continuous controls use their declared
ranges; integer, toggle and enumerated LV2 controls use suitable steps. Octave
pitch switches between down, original and up. Read-only output meters cannot
be assigned.

The assignment is saved with the pedal session when Riffline exits normally and
restored on its next desktop/boot launch, after any saved LV2 plugins are loaded.

## Startup and calibration

`run-pedal.sh` builds and starts `pedal-encoder` alongside the engine, and stops
it when the UI closes. It releases the GPIO inputs on exit. A missing or busy
GPIO device disables the physical controller without stopping audio; the
settings footer reports **OFFLINE**. GPIO request errors appear in
`~/.cache/ml-guitar-pedal/launcher.log`.

The decoder rejects invalid quadrature jumps and cancels contact bounce. It uses
four valid edges per step by default, and a 30 ms stable interval for the button.
Turns are coalesced into at most 25 parameter updates per second. The GPIO event
loop runs in a separate process using the
[Linux GPIO character-device API](https://kernel.org/doc/html/latest/userspace-api/gpio/chardev.html).

Close Riffline before testing these launcher options:

```sh
# Reverse the dial if clockwise currently decreases the value.
PEDAL_ENCODER_REVERSE=1 ./run-pedal.sh

# For encoders whose detents use two transitions instead of four.
PEDAL_ENCODER_EDGES=2 ./run-pedal.sh

# Disable the physical controls while keeping the touchscreen and audio.
PEDAL_ENCODER_DISABLED=1 ./run-pedal.sh
```

`PEDAL_ENCODER_CHIP` can override `/dev/gpiochip0`. The controller checks that the
requested lines are free and named GPIO23/24/25 before claiming them. It never
requests an output direction or writes the ADAC's I2C registers.

## CLI

For the desktop launcher's default socket:

```sh
export PEDAL_CONTROL_SOCKET="$HOME/.cache/ml-guitar-pedal/control.sock"
./build/release/pedalctl encoder assign delay time
./build/release/pedalctl encoder turn 1
./build/release/pedalctl encoder press
./build/release/pedalctl encoder clear
./build/release/pedalctl state
```

The `encoder` object in `state` reports the assignment, current value, controller
heartbeat, pedal bypass state, and whether the pedal is in the active board.
