#!/bin/bash

# Set the starting directory. Defaults to ~/Pictures.
start_dir="${1:-$HOME/Pictures}"

# Check if the starting directory exists
if [ ! -d "$start_dir" ]; then
    wofi --show-error "Directory not found: $start_dir"
    exit 1
fi

# A regex pattern to filter for directories or common image file types.
# This pattern is case-insensitive due to grep's '-i' flag.
filter_pattern='/$|\.(jpg|jpeg|png|gif|bmp|webp|svg|heif|avif)$'

# The text for our custom button
slideshow_button="[🖼️ View All in This Folder]"

# Navigate to the starting directory
cd "$start_dir"

# Main loop for the menu
while true; do
    # --- MODIFIED: We now build the list in a specific order ---
    # We use a subshell '( ... )' to group the output of multiple commands.
    selection=$( (
        # 1. ALWAYS on top: The slideshow button.
        echo "$slideshow_button"

        # 2. SECOND: The 'up' directory, if we are not at the root '/'.
        if [ "$(pwd)" != "/" ]; then
            echo "../"
        fi

        # 3. THE REST: List everything else, sorted, and filtered.
        #    --group-directories-first: Puts all other directories before files.
        #    grep (filter_pattern): Keeps only directories and specified image files.
        #    grep -v (remove . and ..): We exclude './' and '../' because we
        #                               handle '..' manually and don't need '.'.
        ls -aF --group-directories-first | \
            grep -E -i "$filter_pattern" | \
            grep -v -E '^\./$|^\.\./$'

    ) | wofi --dmenu --prompt "$(basename "$(pwd)")/") # Pipe the whole constructed list to wofi

    # Exit if the user presses Esc (selection is empty)
    if [[ -z "$selection" ]]; then
        exit 0
    fi

    # The selection handling logic remains the same and works perfectly.
    if [[ "$selection" == "$slideshow_button" ]]; then
        feh --randomize --scale-down . &
        break
    elif [[ "$selection" == */ ]]; then
        cd "${selection%/}"
        continue
    elif [[ -f "$selection" ]]; then
        feh --scale-down "$selection" &
        break
    fi
done

exit 0
