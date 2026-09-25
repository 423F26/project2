"""Trigger a fixed MIDI note from live ALSA audio volume."""

import subprocess

import numpy as np

SmplRate = 44100
channels = 2
FPB = 1024

threshOn = 0.03
threshOff = 0.015

MIDINote = 60       # C4
MIDIVel = 100


def main() -> None:
    import rtmidi

    midiout = rtmidi.MidiOut()

    cmd = [
        "arecord",
        "-D", "hw:2,0",
        "-f", "S32_LE",
        "-r", str(SmplRate),
        "-c", str(channels),
        "-t", "raw",
        "-q"
    ]

    audio = None

    note_on = False

    print("waiting for input")

    try:
        midiout.open_port(0)
        audio = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        while True:

            data = audio.stdout.read(FPB * channels * 4)

            if not data:
                break

            samples = np.frombuffer(data, dtype="<i4")

            samples = samples.reshape(-1, channels)
            mono = samples.mean(axis=1)

            signal = mono / 2147483648.0  # Normalize signed 32-bit PCM.

            level = np.sqrt(np.mean(signal ** 2))

            # Guitar attack
            if level > threshOn and not note_on:
                midiout.send_message([
                    0x90,
                    MIDINote,
                    MIDIVel
                ])

                note_on = True
                print("NOTE ON")

            elif level < threshOff and note_on:
                midiout.send_message([
                    0x80,
                    MIDINote,
                    0
                ])

                note_on = False
                print("NOTE OFF")

    except KeyboardInterrupt:
        pass

    finally:
        try:
            if note_on:
                midiout.send_message([0x80, MIDINote, 0])
        finally:
            try:
                if audio is not None:
                    audio.terminate()
                    try:
                        audio.wait(timeout=2)
                    except subprocess.TimeoutExpired:
                        audio.kill()
                        audio.wait()
                    audio.stdout.close()
            finally:
                midiout.close_port()

        print("fin")


if __name__ == "__main__":
    main()
