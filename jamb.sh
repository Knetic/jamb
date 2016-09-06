#!/bin/bash

PALETTE_PATH="/tmp/palette.png"

ffmpeg -y -i "$1" -vf fps=10,scale=320:-1:flags=lanczos,palettegen "${PALETTE_PATH}"
ffmpeg -i "$1" -i "${PALETTE_PATH}" -filter_complex "fps=10,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" "$2"

rm "${PALETTE_PATH}"
