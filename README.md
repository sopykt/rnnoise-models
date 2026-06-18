# rnnoise-models

This repository contains the tools and information used to create the various
neural network models in rnnoise-nu. With the exception of the tools/ directory
and this file, none of this work is creative and thus none of it is subject to
copyright.

Note that the name of each model is not meaningful.

## Model information

The following table maps expected signal (horizontal) against expected noise
(vertical). Note that "voice" is distinct from "speech" by the presence of
non-speech human sounds, such as laughter.

|                   | General               | Voice                 | Speech                |
| ----------------- | --------------------- | --------------------- | --------------------- |
| General           | marathon-prescription | leavened-quisling     | orig                  |
| Recording         | conjoined-burgers     | beguiling-drafter     | somnolent-hogwash     |

## Denoising Audio Files (Helper Script)

A helper script `denoise.sh` is included to make it easy to denoise your audio files using FFmpeg's `arnndn` filter and the pre-trained models.

### Prerequisites

Make sure you have `ffmpeg` installed (with `arnndn` filter support):
```bash
ffmpeg -filters | grep arnndn
```

### Usage

```bash
./denoise.sh <input_file> [model_name] [--preview]
```

*   **`input_file`**: Path to the audio file you want to denoise.
*   **`model_name`**: The model you want to use (defaults to `bd`):
    *   `bd` (beguiling-drafter) - Voice with recording noise (e.g. AC/fans) - preserves laugh/cough sounds.
    *   `sh` (somnolent-hogwash) - Speech with recording noise - strictly voice, suppresses non-speech.
    *   `lq` (leavened-quisling) - Voice in a general/heavy noisy environment.
    *   `cb` (conjoined-burgers) - General signal with recording noise.
    *   `mp` (marathon-prescription) - General signal with general/heavy noise.
*   **`--preview`**: Denoises only the first 60 seconds (useful for comparing models quickly).

### Examples

```bash
# Preview the first 60 seconds using beguiling-drafter:
./denoise.sh my_audio.m4a bd --preview

# Denoise the entire file using somnolent-hogwash:
./denoise.sh my_audio.m4a sh
```

