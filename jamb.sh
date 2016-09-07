#!/bin/bash

# Author; George Lester
# Date: 08/2016

# Transcodes a video into a gif.

function showUsage()
{
	echo "Usage: jamb <input video> <output gif location> <horizontal resolution>"
	echo "Horizontal resolution must be a positive number, and represents the amount of pixels wide the resultant gif will be."
}

# Installs proper non-libav ffmpeg from PPA, if it is not already installed.
function checkInstall()
{
	# ref: https://launchpad.net/~mc3man/+archive/ubuntu/trusty-media

	which ffmpeg > /dev/null
	exitStatus=$?

	if [ "${exitStatus}" -ne 0 ];
	then
		echo "ffmpeg is not installed. Installing non-libav ffmpeg from PPA."
		sudo add-apt-repository ppa:mc3man/trusty-media -y
		sudo apt-get update
		sudo apt-get -y install ffmpeg
	fi
}

# Converts the file at the first positional parameter to a gif, located at the second positional parameter.
function convert()
{
	# ref: http://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality
	local PALETTE_PATH="/tmp/palette.png"

	rm -f "${PALETTE_PATH}"

	# Creates a palette file
	ffmpeg -loglevel error -y -i "$1" -vf fps=10,scale=320:-1:flags=lanczos,palettegen "${PALETTE_PATH}"
	exitCode=$?
	if [ "${exitCode}" -ne 0 ];
	then
		echo "Failed to create palette file, aborting."
		exit 2
	fi

	# Encodes as gif, using the above palette file.
	ffmpeg -loglevel error -i "$1" -i "${PALETTE_PATH}" -filter_complex "fps=10,scale=$3:-1:flags=lanczos[x];[x][1:v]paletteuse" "$2"
	exitCode=$?
	if [ "${exitCode}" -ne 0 ];
	then
		echo "Failed to transcode, aborting."
		exit 3
	fi

	rm "${PALETTE_PATH}"
}

if [ "$#" -ne 3 ];
then
	showUsage
	exit 1
fi

checkInstall
convert "$1" "$2" "$3"
