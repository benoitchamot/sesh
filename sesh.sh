#!/bin/sh
# Usage: sesh/ [subdir]
# Starts a TMUX session in the subdirectory of the /repos directory
# If no argument is passed, list available repos in fzf
# Left pane will always show a shell
# Right pane will always show a terminal

set -e # Exit on any error

BASE_DIR="$HOME/repos"

# Make sure the repo dir exists
if [ ! -d "$BASE_DIR" ]; then
    echo "Error: Base directory $BASE_DIR does not exists."
    exit 1
fi

# Get the subdir argument or open fzf with a list of directories
# in the base directory
if [ -z "$1" ]; then

    # Get the subdirs into an array
    mapfile -t DIRS < <(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)

    # Assumes that fzf is installed and directories exist in repos
    echo "Select a project:"
    SUBDIR=$(printf "%s\n" "${DIRS[@]}" | fzf --prompt="Project> ")

# If an argument is passed, just use the argument
else
    SUBDIR="$1"
fi

# If no subdir exists, exit
if [ -z "$SUBDIR" ]; then
    echo "No project selected"
    exit 1
fi

TARGET_DIR="$BASE_DIR/$SUBDIR"

# Create if doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

# Move to target and create session (remove trailing empties)
cd "$TARGET_DIR"
SESSION_NAME="dev_${SUBDIR//[^a-zA-Z0-9_]/_}"

# Attach to existing session
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach -t "$SESSION_NAME"
    exit 0
fi

# Create a new session (and activate venv if there is one)
echo "$SESSION_NAME"
tmux new-session -d -s "$SESSION_NAME" -c "$TARGET_DIR" \
    "if [ -d .venv ]; then source .venv/bin/activate; fi; exec bash"

# Add nvim to right pane
tmux split-window -h -t "$SESSION_NAME" -c "$TARGET_DIR" "nvim ."

# OPTIONAL: focus on left pane
tmux select-pane -t 1 

tmux attach -t "$SESSION_NAME"

