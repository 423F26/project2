# Live audio and control

`pedal-engine` runs the ALSA audio loop and polls a local Unix socket. The command protocol supports `state`, `status`, `clean`, `effect`, `toggle`, `amount N`, `board ID,ID`, `config ID SETTING VALUE`, `lv2-list`, and `lv2-load URI`. A board of `-` clears the active chain. `pedalctl` sends commands directly; `pedal-web` handles browser JSON endpoints. The control socket can be set with `PEDAL_CONTROL_SOCKET`.

The engine also supports `tuner on`, `tuner off`, and `midi-events`. `state` includes a `tuner` object with note, frequency, cents, confidence, and enabled fields, plus MIDI queue counts. `midi-events` returns and drains queued messages. The browser uses `POST /api/tuner` to change tracking and `GET /api/midi` to read events.
