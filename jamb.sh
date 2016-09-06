#!/bin/bash

PALETTE_PATH="/tmp/palette.png"

function showUsage()
{
	echo "Usage: jamb <input video> <output gif location>"
}

if [ "$#" -ne 2 ];
then
	showUsage
	exit 1
fi

ffmpeg -y -i "$1" -vf fps=10,scale=320:-1:flags=lanczos,palettegen "${PALETTE_PATH}"
exitCode=$?
if [ "${exitCode}" -ne 0 ];
then
	echo "Failed to create palette file, aborting."
	exit 2
fi

ffmpeg -i "$1" -i "${PALETTE_PATH}" -filter_complex "fps=10,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" "$2"
exitCode=$?
if [ "${exitCode}" -ne 0 ];
then
	echo "Failed to transcode, aborting."
	exit 3
fi

rm "${PALETTE_PATH}"
