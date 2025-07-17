#!/usr/bin/env bash

# The top-level directory to start in.
VIDEOS_DIR="$HOME/Videos"
current_dir="$VIDEOS_DIR"

# Start an infinite loop for navigation.
while true; do
    # Create a user-friendly path for the wofi prompt.
    prompt_path=$(realpath --relative-to="$HOME" "$current_dir")

    # --- Generate the list for wofi ---
    # The list contains our custom actions, followed by all files and folders.
    selection=$( (
        # 1. Add our custom "Play All" action.
        echo "▶ Play All"

        # 2. Add a ".." entry to go up, if we're not at the top level.
        if [[ "$current_dir" != "$VIDEOS_DIR" ]]; then
            echo ".."
        fi

        # 3. Find ALL items (files and folders) one level deep and sort them.
        find "$current_dir" -maxdepth 1 -mindepth 1 -printf "%f\n" | sort
    ) | wofi --dmenu --prompt "$prompt_path/")

    # If the user presses Esc, exit the script.
    if [[ -z "$selection" ]]; then
        exit 0
    fi

    # --- Handle the user's selection ---

    # Case 1: The user selected our custom "Play All" action.
    if [[ "$selection" == "▶ Play All" ]]; then
        mpv "$current_dir"
        exit 0

    # Case 2: The user selected ".." to go up a directory.
    elif [[ "$selection" == ".." ]]; then
        current_dir=$(dirname "$current_dir")
        continue # Restart the loop to show the parent directory.

    # Case 3: The user selected a real file or directory from the list.
    else
        # Reconstruct the full path of the selected item.
        full_path="$current_dir/$selection"

        # If the selection is a FILE, play it and exit.
        if [[ -f "$full_path" ]]; then
            mpv "$full_path"
            exit 0

        # If the selection is a DIRECTORY, navigate into it.
        elif [[ -d "$full_path" ]]; then
            # Simply update the current directory and let the loop run again.
            current_dir="$full_path"
        fi
    fi
done
