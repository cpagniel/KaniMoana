#!/bin/bash

#  install_KaniMoana.sh
#
#
#  Author: Camille Pagniello
#  Last Edit: 04/23/2022
#  Script to schedule wittyPi and record audio
#

echo "Welcome to KaniMoana"
echo "Beginning installation..."
echo ""

# ------------------------------------------------------------
# Update and Upgrade Bullseye OS
# ------------------------------------------------------------

echo "Updating and upgrading Bullseye OS..."
echo ""

sudo apt-get update
sudo apt update
echo "Y" | sudo apt upgrade

# ------------------------------------------------------------
# Configure RaspberryPi
# ------------------------------------------------------------

echo "Configuring RPi..."

echo "Set hostname to kanimoana1."
sudo hostname kanimoana1

echo "Set timezone to US/Hawaii."
sudo timedatectl set-timezone US/Hawaii

# ------------------------------------------------------------
# Install WittyPi3
# ------------------------------------------------------------

echo "Installing WittyPi3..."
echo ""

cd /home/pi
sudo wget http://www.uugear.com/repo/WittyPi3/install.sh
sudo sh install.sh

echo "Y" | rm install.sh

# ------------------------------------------------------------
# Configure USB Mount Location
# ------------------------------------------------------------

echo "Creating USB mount location..."
echo ""

cd /media
sudo mkdir DATA
sudo chown -R pi:pi /media/DATA

# ------------------------------------------------------------
# Configure KaniMoana Directories
# ------------------------------------------------------------

echo "Creating directories for KaniMoana..."
echo "
"
cd /home/pi
sudo mkdir kanimoana

cd /home/pi/kanimoana
mkdir config

# ------------------------------------------------------------
# Get KaniMoana Configuration Files from GitHub
# ------------------------------------------------------------

echo "Downloading KaniMoana configuration files from GitHub..."
echo ""

cd /home/pi/kanimoana/config

wget https://raw.githubusercontent.com/cpagniel/KaniMoana/master/software/config/config.txt
cp config.txt /boot

wget https://raw.githubusercontent.com/cpagniel/KaniMoana/master/software/config/asound.conf
cp asound.conf /etc

# ------------------------------------------------------------
# Get KaniMoana Software from GitHub
# ------------------------------------------------------------

echo "Downloading KaniMoana software from GitHub..."
echo ""

cd /home/pi/kanimoana

wget https://raw.githubusercontent.com/cpagniel/KaniMoana/master/software/scripts/KaniMoana.sh
chmod +x KaniMoana.sh

wget https://raw.githubusercontent.com/cpagniel/KaniMoana/master/software/scripts/audio_recording.sh
chmod +x audio_recording.sh

# ------------------------------------------------------------
# Edit .bashrc
# ------------------------------------------------------------

echo "Editing .bashrc..."
echo ""

cd /home/pi

echo "" >> ~/.bashrc
echo "# Audio Capture for KaniMoana" >> ~/.bashrc
echo "" >> ~/.bashrc
echo "sleep 10" >> ~/.bashrc
echo "cd /home/pi/kanimoana" >> ~/.bashrc
echo "sudo ./KaniMoana.sh" >> ~/.bashrc

# ------------------------------------------------------------
# Shutdown to Add WittyPi & HifiBerry
# ------------------------------------------------------------

echo "Installation sucessful!"
echo ""

echo "Shutting down to add WittyPi & HifiBerry hats."
echo ""

sudo shutdown -h now