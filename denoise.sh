#!/bin/bash

# Denoising script using FFmpeg's arnndn filter and pre-trained models

if [ -z "$1" ]; then
    echo "Usage: $0 <input_file> [model_name] [--preview]"
    echo ""
    echo "Available Models:"
    echo "  1) bd (beguiling-drafter)     - Voice with recording noise (fans, AC, etc. - preserves laughs/coughs)"
    echo "  2) sh (somnolent-hogwash)     - Speech with recording noise (strictly speech, no laughs/coughs)"
    echo "  3) lq (leavened-quisling)     - Voice with general/heavy noise"
    echo "  4) cb (conjoined-burgers)     - General signal with recording noise"
    echo "  5) mp (marathon-prescription) - General signal with general/heavy noise"
    echo ""
    echo "Examples:"
    echo "  $0 input.m4a bd            # Denoises whole file using beguiling-drafter"
    echo "  $0 input.m4a sh --preview  # Denoises first 60 seconds using somnolent-hogwash"
    exit 1
fi

INPUT_FILE="$1"
MODEL_CHOICE="${2:-bd}"
PREVIEW=false

if [ "$3" = "--preview" ] || [ "$2" = "--preview" ]; then
    PREVIEW=true
    if [ "$2" = "--preview" ]; then
        MODEL_CHOICE="bd"
    fi
fi

# Map model choice to relative file path
case "$MODEL_CHOICE" in
    bd|beguiling-drafter)
        MODEL_PATH="beguiling-drafter-2018-08-30/bd.rnnn"
        MODEL_NAME="bd"
        ;;
    sh|somnolent-hogwash)
        MODEL_PATH="somnolent-hogwash-2018-09-01/sh.rnnn"
        MODEL_NAME="sh"
        ;;
    lq|leavened-quisling)
        MODEL_PATH="leavened-quisling-2018-08-31/lq.rnnn"
        MODEL_NAME="lq"
        ;;
    cb|conjoined-burgers)
        MODEL_PATH="conjoined-burgers-2018-08-28/cb.rnnn"
        MODEL_NAME="cb"
        ;;
    mp|marathon-prescription)
        MODEL_PATH="marathon-prescription-2018-08-29/mp.rnnn"
        MODEL_NAME="mp"
        ;;
    *)
        echo "Error: Unknown model '$MODEL_CHOICE'"
        exit 1
        ;;
esac

if [ ! -f "$MODEL_PATH" ]; then
    echo "Error: Model file not found at $MODEL_PATH"
    exit 1
fi

# Define output filename
FILENAME="${INPUT_FILE%.*}"
EXTENSION="${INPUT_FILE##*.}"

if [ "$PREVIEW" = true ]; then
    OUTPUT_FILE="${FILENAME}_preview_${MODEL_NAME}.${EXTENSION}"
    echo "Generating 60-second denoised preview: $OUTPUT_FILE using model: $MODEL_NAME"
    ffmpeg -y -ss 00:00:00 -t 60 -i "$INPUT_FILE" -af "arnndn=model=$MODEL_PATH" -c:a aac -b:a 128k "$OUTPUT_FILE"
else
    OUTPUT_FILE="${FILENAME}_denoised_${MODEL_NAME}.${EXTENSION}"
    echo "Denoising full file: $OUTPUT_FILE using model: $MODEL_NAME"
    ffmpeg -y -i "$INPUT_FILE" -af "arnndn=model=$MODEL_PATH" -c:a aac -b:a 128k "$OUTPUT_FILE"
fi

echo "Done!"
