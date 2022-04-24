#!/bin/sh

#  audio_recording.sh
#
#
#  Author: Camille Pagniello
#  Last Edit: 04/23/2022
#  Script for audio recording
#
# ------------------------------------------------------------
# Setup Environment
# ------------------------------------------------------------

echo ""
echo "Start audio_recording.sh"
echo ""

# ------------------------------------------------------------
# Write to .log file
# ------------------------------------------------------------

RUNFILE="KaniMoana1.log"

cd /media/DATA && echo "Start Time of audio_recording.sh" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Starting audio capture...
# ------------------------------------------------------------

cd /media/DATA && echo "Start Time of audio capture:" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Audio capture
# ------------------------------------------------------------

# Record for 60-minute (3600 seconds) wav file at 48 kHz with 16-bit resolution.

cd /media/DATA

arecord -D sysdefault:CARD=sndrpihifiberry -r 48000 -d 3600 -f S16_LE -t wav -V mono KaniMoana1.$(date +%Y%m%d%H%M%S).wav

# ------------------------------------------------------------
# Ending audio capture...
# ------------------------------------------------------------

cd /media/DATA && echo "End Time of audio capture:" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------

echo ""
echo "Cleaning up"

cd /media/DATA && echo "End Time of audio_recording.sh" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Exit
# ------------------------------------------------------------

echo ""
echo "Exit audio_recording.sh"
echo ""
exit 0
