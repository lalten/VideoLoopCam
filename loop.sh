#!/bin/bash
# Make a loopable video by crossfading its end over its start
#
# Before:
# +--------------------------------------------------+
# | first                                | second    |
# +--------------------------------------------------+
# 0                    $UNFADED_DURATION ^       end ^
# 
# After:
# +-----------+
# | second    |
# +-----------+
# |-crossfade-|
# +-----------+--------------------------+
# | first                                |
# +--------------------------------------+
# 0           ^ $CROSSFADE_DURATION

set -eu

RECORDING_FILENAME="recording.mkv"
OUTPUT_LOOP_FILE="${RECORDING_FILENAME%%.*}-loop.${RECORDING_FILENAME#*.}"
CROSSFADE_DURATION=2

DURATION="$( \
    ffprobe -v error \
    -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 \
    "$RECORDING_FILENAME" \
    )"

UNFADED_DURATION=$(echo "$DURATION-$CROSSFADE_DURATION" | bc)
FADE_IN="if(gte(T,$CROSSFADE_DURATION),
        1,
        T/$CROSSFADE_DURATION
    )"
FADE_OUT="if(gte(T,$CROSSFADE_DURATION),
        0,
        1-(T/$CROSSFADE_DURATION)
    )"

ffmpeg \
    -loglevel warning \
    -y \
    -i "$RECORDING_FILENAME" \
    -filter_complex "
    [0]
        split
        [in0][in1];
    [in0]
        trim=end=$UNFADED_DURATION
        [first];
    [in1]
        trim=start=$UNFADED_DURATION,
        setpts=PTS-STARTPTS
        [second];
    [second][first]
        blend=all_expr=
            'A*($FADE_OUT)
            +B*($FADE_IN)'
    " \
    "$OUTPUT_LOOP_FILE"

# Play
mpv --loop "$OUTPUT_LOOP_FILE"
