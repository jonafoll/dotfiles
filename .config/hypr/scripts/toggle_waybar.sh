#!/bin/bash

# Check if a process named "waybar" is running
if pgrep -x "waybar" > /dev/null
then
    # If it is, kill it
    killall waybar
else
    # If it's not, start it
    waybar &
fi
