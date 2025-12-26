#!/usr/bin/env bash
# Generate terminal screenshot using tmux + iTerm
# Usage: ./capture.sh [-o output.png] [-w width] command...
# Example: ./capture.sh -o perldoc.png perldoc App::optex::up

set -e

declare -A OPTS=(
    [ output |o: # output filename            ]=screenshot.png
    [ width  |w: # terminal width             ]=180
    [ shadow |s  # capture with window shadow ]=1
    [ keys   |k: # send keys after command    ]=
    [ help   |h  # show help                  ]=
)

. getoptlong.sh OPTS "$@" || exit 1

if [[ -n "$help" ]] || [[ $# -eq 0 ]]; then
    echo "Usage: $0 [-o output.png] [-w width] command..."
    echo "Example: $0 -o perldoc.png perldoc App::optex::up"
    exit 0
fi

OUTPUT="$output"
WIDTH="$width"
COMMAND="$*"
SESSION="screenshot_$$"

cleanup() {
    tmux kill-session -t "$SESSION" 2>/dev/null || true
}
trap cleanup EXIT

# Create tmux session and run command
tmux new-session -d -s "$SESSION" -x $WIDTH
sleep 0.5

# Disable status bar for clean screenshot
tmux set-option -t "$SESSION" status off

# Create iTerm window and attach to tmux
osascript <<EOF
tell application "iTerm"
    create window with default profile
    delay 0.3
    set newWin to window 1

    -- Set window size
    set bounds of newWin to {50, 50, 1450, 1000}
    delay 0.3

    tell current session of newWin
        write text "tmux attach -t $SESSION"
    end tell
    delay 1
end tell
EOF

# Run command after iTerm attach (terminal size will be correct)
tmux send-keys -t "$SESSION" "clear && $COMMAND" Enter
sleep 2

# Send additional keys if specified (e.g., Space for next page in less)
if [[ -n "$keys" ]]; then
    tmux send-keys -t "$SESSION" "$keys"
    sleep 1
fi

# Capture screenshot
if [[ $shadow ]]; then
    # Capture with window shadow
    osascript <<EOF
tell application "iTerm"
    set newWin to window 1
    delay 0.3

    -- Get window ID for screencapture with shadow
    set winID to id of newWin

    -- Capture window with shadow
    do shell script "screencapture -l " & winID & " $OUTPUT"

    -- Close the window
    close newWin
end tell
EOF
else
    # Capture rectangle region without shadow
    osascript <<EOF
tell application "iTerm"
    set newWin to window 1
    delay 0.3

    -- Get window bounds and capture
    set winBounds to bounds of newWin
    set x1 to item 1 of winBounds
    set y1 to item 2 of winBounds
    set x2 to item 3 of winBounds
    set y2 to item 4 of winBounds
    set w to x2 - x1
    set h to y2 - y1

    do shell script "screencapture -R" & x1 & "," & y1 & "," & w & "," & h & " $OUTPUT"

    -- Close the window
    close newWin
end tell
EOF
fi

if [ -f "$OUTPUT" ]; then
    echo "Screenshot saved: $OUTPUT"
    ls -la "$OUTPUT"
else
    echo "Failed to create screenshot" >&2
    exit 1
fi
