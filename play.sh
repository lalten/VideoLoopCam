#!/bin/bash
# Create a v4l2 loopback and stream a video file into it.

set -eu

INPUT_FILE="recording-loop.mkv"
OUTPUT_CAM_DEVNR=10
OUTPUT_CAM_DEVFILE="/dev/video$OUTPUT_CAM_DEVNR"

# Set up v4l2loopback
if [[ ! -c $OUTPUT_CAM_DEVFILE ]]; then
    sudo rmmod v4l2loopback || true
    sudo modprobe v4l2loopback \
        video_nr=$OUTPUT_CAM_DEVNR \
        card_label="VideoLoopCam" \
        exclusive_caps=1
fi

# Stream video loop
ffmpeg \
    -loglevel warning \
    -stream_loop -1 -re  -i "$INPUT_FILE" \
    -f v4l2 -pix_fmt yuv420p "$OUTPUT_CAM_DEVFILE"
