# Live audio and control

`pedal-engine` runs the ALSA audio loop and polls a local Unix socket. The command protocol supports `state`, `status`, `clean`, `effect`, `toggle`, `amount N`, `board ID,ID`, `config ID SETTING VALUE`, `lv2-list`, and `lv2-load URI`. A board of `-` clears the active chain. `pedalctl` sends commands directly; `pedal-web` handles browser JSON endpoints. The control socket can be set with `PEDAL_CONTROL_SOCKET`.
