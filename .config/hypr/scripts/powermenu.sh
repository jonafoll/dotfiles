#!/bin/bash

# Options for wofi
options="  Shutdown\n  Reboot\n  Sleep\n  Lock\n  Logout"

# Use wofi's native mode with a dmenu backend
# --show dmenu: Use the modern UI (search bar + results list)
# --ignore-case: Make searching case-insensitive
chosen_option=$(echo -e "$options" | wofi --dmenu --ignore-case --prompt "Power Menu")

# Execute the command based on the choice
case "$chosen_option" in
  "  Shutdown")
    systemctl poweroff
    ;;
  "  Reboot")
    systemctl reboot
    ;;
  "  Sleep")
    hyprlock && sleep 0.5 && systemctl suspend
    ;;
  "  Lock")
    hyprlock 
    ;;
  "  Logout")
    hyprctl dispatch exit
    ;;
  *)
    # If the user Escapes or chooses nothing, do nothing
    ;;
esac
