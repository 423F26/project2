# Development workflow

## Set up and verify

Use Python 3.11 or newer. From the repository root:

```bash
uv sync
uv run python -m unittest discover -s tests
uv run pedal --help
```

The package and `pedal` entry point are declared in `pyproject.toml`; dependency versions are locked in `uv.lock`. The tests use `unittest`. `tests/test_effect.py` checks DSP state, mode fading, socket control, and parser defaults. `tests/test_pitch_classifier.py` checks WAV reading, feature extraction, classifier behavior, streaming frames, and interactive settings.

GitHub Actions runs this test suite on every push with Python 3.11 and the locked dependencies in `uv.lock`.

## Documentation website

The [documentation site](https://423f26.github.io/project2/) publishes the repository README, user and developer guides, touchscreen and hardware guides, agile workbooks, and hardware reference files. To build it locally from the repository root:

```bash
python -m pip install -r requirements-docs.txt
python scripts/build_docs.py
```

The site is written to `build/site/`. The build uses MkDocs strict mode to catch broken documentation links. Pushes to `main` that change documentation or site configuration publish it through GitHub Actions.

These tests do not validate an ALSA device, physical GPIO switch, MIDI port, or SSH/browser connection. Test those paths on the target hardware after changing their modules.

## Where to change behavior

| Change | Main files | Follow-up check |
| --- | --- | --- |
| ALSA device selection or stream parameters | `alsa_pcm.py`, `effect.py` | `pedal effect --list-devices`, then a manual capture/playback check |
| Pedal graph order, fuzz/overdrive, or bypass transition | `processing.py`, `effect.py` | `test_effect.py`, then listen for level and click changes |
| Mode, amount, footswitch, or browser control | `control.py`, `footswitch.py`, `demo_ui.py` | Local socket tests, then target Pi control check |
| Dataset names or labels | `dataset.py`, `cli.py` | Scan representative files and check label counts |
| Audio decoding or feature extraction | `audio.py`, `features.py` | Synthetic WAV tests, then train and predict against representative recordings |
| Model or saved JSON format | `model.py`, `cli.py` | Model tests, save/load round trip, and compatibility review |
| Benchmark framing | `streaming.py`, `cli.py` | Frame tests and a representative benchmark |

`data/` and `models/` are ignored by Git. Do not assume a fresh checkout has recordings or a trained model. The agile spreadsheets are planning artifacts; their completion and latency claims need separate evidence before being presented as verified results.
