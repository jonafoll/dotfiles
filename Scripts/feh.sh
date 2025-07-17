#!/bin/bash

# Set the starting directory. Defaults to ~/Pictures.
start_dir="${1:-$HOME/Pictures}"

# Check if the starting directory exists
if [ ! -d "$start_dir" ]; then
    wofi --show-error "Directory not found: $start_dir"
    exit 1
fi

# Navigate to the starting directory
cd "$start_dir"

# --- MODIFIED: More accurate button text ---
slideshow_button="[View All in Folder]"

# Main loop for the menu
while true; do
    # Prepend our custom button to the 'ls' output.
    selection=$( (echo "$slideshow_button"; ls -aF) | wofi --dmenu --prompt "$(basename "$(pwd)")/")

    # Exit if the user presses Esc (selection is empty)
    if [[ -z "$selection" ]]; then
        exit 0
    fi

    # Check if our custom button was selected first
    if [[ "$selection" == "$slideshow_button" ]]; then
        # --- CORRECTED COMMAND ---
        # Run feh on the current directory ('.').
        # --randomize: shows images in a random order.
        # --scale-down: fits images to the screen.
        # We have REMOVED --recursive to only show images in the current directory.
        feh --randomize --scale-down . &
        break
    # If the selection ends with a "/", it's a directory.
    elif [[ "$selection" == */ ]]; then
        cd "${selection%/}"
        continue
    # If the selection is a regular file.
    elif [[ -f "$selection" ]]; then
        feh --scale-down "$selection" &
        break
    fi
done

exit 0
