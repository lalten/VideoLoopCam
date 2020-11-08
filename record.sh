#!/bin/bash
# Record webcam input with a preview where the first frame is overlayed.
# Stop recording with `Q` or `ESC` keys in SDL window (or Ctrl+C on cmd line)

set -eu

INPUT_WEBCAM="/dev/video0"
INPUT_WIDTH="1280"
INPUT_HEIGHT="720"
INPUT_FORMAT="mjpeg"
INPUT_FRAMERATE="30"
RECORDING_FILENAME="recording.mkv"

v4l2-ctl -v width=$INPUT_WIDTH,height=$INPUT_HEIGHT -d "$INPUT_WEBCAM"
ffmpeg \
    -loglevel warning \
    -y \
    -f v4l2 -input_format "$INPUT_FORMAT" -framerate "$INPUT_FRAMERATE" -i "$INPUT_WEBCAM" \
    -filter_complex "
    [0]
        split=3
        [in1][in2][in3];
    [in2]
        loop=loop=-1:size=1:start=0
        [overlayframe];
    [in3][overlayframe]
        framestep=2,
        blend=all_mode=average,
        hflip,
        format=yuv420p
        [preview]
    " \
    -map '[in1]' -f matroska "$RECORDING_FILENAME" \
    -map '[preview]' -f sdl -

