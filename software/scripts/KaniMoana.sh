#!/bin/bash

#  KaniMoana.sh
#
#
#  Author: Camille Pagniello
#  Last Edit: 04/24/2022
#  Script to schedule wittyPi and record audio
#
# ------------------------------------------------------------
# Setup Environment
# ------------------------------------------------------------

echo ""

echo "Welcome to KaniMoana"
echo "Current Time:" $(date)

# ------------------------------------------------------------
# Mount USB
# ------------------------------------------------------------

cd /home/pi/kanimoana

sudo mount /dev/sda1 /media/DATA -o uid=pi,gid=pi
USBID="sda1" && sudo echo sda1 > usb_id.txt
USBNAME=$(sudo blkid | grep $USBID | cut -b 27-31)

# ------------------------------------------------------------
# Create .log file
# ------------------------------------------------------------

echo ""
echo "Create .log"

RUNFILE="KaniMoana1.log"

cd /media/DATA && echo "Start Time of KaniMoana.sh" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Adjust Gain
# ------------------------------------------------------------

# Boost the hydrophone signal as it is very low.

# The values of this command are steps between 0 and 104 and will set ADC volume 0.5db/step. So 96 is about 48dB. You may adjust this value to a lower level depending on the sensitivity.

echo ""
echo "Adjust Gain"
cd /media/DATA && sudo echo "ADC gain: 48 dB" >> "${RUNFILE}"
amixer -D sysdefault -c sndrpihifiberry cset name='ADC Capture Volume' 96,96

# ------------------------------------------------------------
# Infinite Loop
# ------------------------------------------------------------

while true
do

  # ------------------------------------------------------------
  # USB Name
  # ------------------------------------------------------------

  echo ""
  cd /media/DATA && echo "Data stored to:" $USBNAME
  cd /media/DATA && sudo echo "Data stored to:" $USBNAME >> "${RUNFILE}"

  # ------------------------------------------------------------
  # Audio Recording
  # ------------------------------------------------------------

  cd /home/pi/kanimoana
  sudo ./audio_recording.sh

  # ------------------------------------------------------------
  # Temperature
  # ------------------------------------------------------------

  . /home/pi/wittypi/utilities.sh

  cd /home/pi/wittypi && temp="$(get_temperature)"
  cd /media/DATA && sudo echo "wittyPi Temperature at" $(date +%T)":" $temp >> "${RUNFILE}"

  # ------------------------------------------------------------
  # Check USB space
  # ------------------------------------------------------------

  cd /home/pi/kanimoana && sudo rm usb_space.txt
  du -s /media/DATA | grep -o -E '[0-9]+' > /home/pi/kanimoana/usb_space.txt

  cd /home/pi/kanimoana
  if [ $(cat usb_space.txt) -ge 494085041152 ]; then
      echo ""
      echo $USBNAME "is full"
      if [ $USBID = "sda1" ]; then
          sudo rm usb_id.txt && sudo echo sdb1 > usb_id.txt
          sudo umount -f /dev/$USBID

          USBID=$(cat usb_id.txt)
          sudo mount /dev/$USBID /media/DATA -o uid=pi,gid=pi
          USBNAME=$(sudo blkid | grep $USBID | cut -b 19-23)
      elif [ $USBID = "sdb1" ]; then
          sudo rm usb_id.txt && sudo echo sdc1 > usb_id.txt
          sudo umount -f /dev/$USBID

          USBID=$(cat usb_id.txt)
          sudo mount /dev/$USBID /media/DATA -o uid=pi,gid=pi
          USBNAME=$(sudo blkid | grep $USBID | cut -b 19-23)
      elif [ $USBID = "sdc1" ]; then
          sudo rm usb_id.txt && sudo echo FULL > usb_id.txt
          sudo umount -f /dev/$USBID

          $USBNAME="Native"

          cd /media && mkdir DATA
          cd /media/DATA
      fi
  fi

  cd /media/DATA && echo "" >> "${RUNFILE}"

done

# ------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------

echo ""
echo "Cleaning up"

# Write .run
cd /media/DATA && sudo echo "End Time of KaniMoana.sh" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Exit
# ------------------------------------------------------------

echo "Exit KaniMoana.sh "
echo ""
exit 0
