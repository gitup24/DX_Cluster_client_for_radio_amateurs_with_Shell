#!/bin/bash

# make executable : chmod +x client.sh
# execute : ./client.sh

# Configuration
DX_SERVER="dxc.nc7j.com"
DX_PORT=7373
CALLSIGN="on1od"
BEEP_SOUND="beep.wav"  # Sound file path

# Checks if VLC is installed
if ! command -v vlc &>/dev/null; then
  echo "VLC is not installed. Please install it before running this script."
  exit 1
fi

# Connection to the server and data's processing
(
  sleep 1
  echo "$CALLSIGN"

  # Infinite loop to process server output
  while true; do
    # Using telnet to read output line by line
    telnet $DX_SERVER $DX_PORT | while read -r line; do
      echo "$line"  # Displays the line received
      if echo "$line" | grep -iq "ua"; then  # Search for “k” (case insensitive)
        echo "ua found"  # Display a message
        echo -e '\a'  # Emits a beep
        vlc --intf dummy --play-and-exit "$BEEP_SOUND" &>/dev/null  # Plays sound file
      fi
    done
  done
) 2>&1
