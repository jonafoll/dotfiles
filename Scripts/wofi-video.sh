#!/usr/bin/env bash

# The top-level directory to start in.
VIDEOS_DIR="$HOME/Videos"
current_dir="$VIDEOS_DIR"

# Start an infinite loop for navigation.
while true; do
    # Create a user-friendly path for the prompt.
    prompt_path=$(realpath --relative-to="$HOME" "$current_dir")

    # --- Generate the list for wofi ---
    # The list is constructed to have our custom actions at the top,
    # followed by a sorted list of files and folders.
    selection=$( (
        # Add our custom "Play All" action. The '▶' symbol makes it stand out.
        echo "▶ Play All"

        # Add a ".." entry to go up, but only if we're not at the top level.
        if [[ "$current_dir" != "$VIDEOS_DIR" ]]; then
            echo ".."
        fi

        # Now, find all files/folders in the current directory and sort them.
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
        exit 0 # Job done, exit.

    # Case 2: The user selected ".." to go up a directory.
    elif [[ "$selection" == ".." ]]; then
        current_dir=$(dirname "$current_dir")
        continue # Go to the next loop iteration to show the new directory.

    # Case 3: The user selected a real file or directory.
    else
        # Reconstruct the full path of the selected item.
        full_path="$current_dir/$selection"

        # If it's a file, play it and exit.
        if [[ -f "$full_path" ]]; then
            mpv "$full_path"
            exit 0

        # If it's a directory, check if it's a "leaf" or has more folders.
        elif [[ -d "$full_path" ]]; then
            # Check for any sub-directories inside the selection.
            has_subdirs=$(find "$full_path" -mindepth 1 -maxdepth 1 -type d -print -quit)

            if [[ -z "$has_subdirs" ]]; then
                # It's a "leaf" folder. Play the whole thing and exit.
                mpv "$full_path"
                exit 0
            else
                # It's a parent folder. Navigate into it for the next loop.
                current_dir="$full_path"
            fi
        fi
    fi
done
