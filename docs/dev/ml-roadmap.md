# Where ML fits in the C pedal

The live audio path should remain predictable: ALSA capture, C effects, tuner, and MIDI event transport. The tuner is a deterministic pitch baseline, not an ML model. Learned inference can run alongside the audio path and send bounded control changes back to the engine; it should never block an audio callback or allocate memory in the time-critical path.

## First ML release: gesture-aware effects

Recognize a small set of playing gestures, such as palm-muted rhythm, sustained notes, and strong attacks. An opt-in **Assist** control can use those predictions to adjust an active pedal's drive or delay mix smoothly. Keep every effect adjustable by hand and make the Assist strength visible and bypassable. This gives the model a musical purpose that a normal tuner or fixed preset does not provide.

Start with a small labeled dataset from several guitars, pickups, and playing levels. Compare the model with simple level and onset rules on recordings that were not used for training. Track false setting changes per minute, confidence, CPU use, and added control latency on the target Raspberry Pi. If confidence is low, keep the current settings.

## Later options

- **Pitch-to-MIDI refinement:** use the current tuner events as a baseline, then train a model to improve note-on timing and reject harmonics, noise, and false notes. The former clean-tone dataset may help, but it needs broader recordings and note-on labels.
- **Tone matching:** given a reference clip, recommend a pedal chain and settings. Run this as an offline or user-invoked step before trying real-time neural audio processing.
- **Personal adaptation:** let a player accept or reject suggested settings so the control model learns their guitar and style without changing the manual board unexpectedly.

Training and data preparation can happen outside the C runtime. Export a compact model asset and run inference from C in a worker with a fixed queue of audio features. Feed approved parameter changes to the engine through its existing control path, with smoothing and a manual override. Choose a portable inference runtime only after measuring the model and CPU budget on the target hardware.
