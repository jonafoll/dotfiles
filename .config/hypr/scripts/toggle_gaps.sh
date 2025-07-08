#!/bin/bash

# Define the gap sizes you want when toggled ON.
GAPS_IN_ON=3
GAPS_OUT_ON=10

# All gaps will be set to 0 when toggled OFF.
GAPS_OFF=0

# Get the current gaps_in value to check the state reliably.
current_gaps_in=$(hyprctl getoption general:gaps_in | grep 'int:' | awk '{print $2}')

# Toggle the gaps
if [ "$current_gaps_in" -eq "$GAPS_OFF" ]; then
    # If gaps are OFF, turn them ON
    hyprctl --batch "\
        keyword general:gaps_in $GAPS_IN_ON;\
        keyword general:gaps_out $GAPS_OUT_ON"
else
    # If gaps are ON, turn them OFF
    hyprctl --batch "\
        keyword general:gaps_in $GAPS_OFF;\
        keyword general:gaps_out $GAPS_OFF"
fi
