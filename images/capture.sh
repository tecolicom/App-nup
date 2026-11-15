#!/usr/bin/env bash
#
# Generate terminal screenshot using iTerm and macOS screencapture.
#
# Opens a new iTerm window with specified terminal size, runs the
# given command, waits for output to render, then captures the
# window as a PNG image.
#
# Requires: iTerm2, macOS screencapture, getoptlong.sh
#
# Note: On Retina displays, the window is captured at 2x resolution.
# The image is then reduced to the size of the window in points, so
# that it is the same as one taken on a non-Retina display.  Use
# --hires to keep the captured resolution.
#
# Usage: ./capture.sh [-o output.png] [-c cols] [-r rows] command...
# Example: ./capture.sh -o nup.png 'nup man nup'

set -e

declare -A OPTS=(
    [ output |o: # output filename            ]=screenshot.png
    [ cols   |c: # terminal columns           ]=180
    [ rows   |r: # terminal rows              ]=50
    [ shadow |s  # capture with window shadow ]=1
    [ delay  |d: # delay before capture (sec) ]=2
    [ keys   |k: # send keys after command    ]=
    [ hires  |H  # keep the Retina resolution  ]=
    [ help   |h  # show help                  ]=
)

. getoptlong.sh OPTS "$@" || exit 1

if [[ -n "$help" ]] || [[ $# -eq 0 ]]; then
    echo "Usage: $0 [-o output.png] [-c cols] [-r rows] command..."
    echo "Example: $0 -o nup.png 'nup man nup'"
    exit 0
fi

OUTPUT="$output"
COMMAND="$*"

# Create iTerm window, run command, and get window ID
WIN_ID=$(osascript <<EOF
tell application "iTerm"
    set newWin to (create window with default profile)
    delay 0.3

    tell current session of newWin
        -- Set terminal size
        set columns to $cols
        set rows to $rows

        -- Run command
        write text "$COMMAND"
    end tell

    return id of newWin
end tell
EOF
)

sleep "$delay"

# Send additional keys if specified (e.g., Space for next page in less)
if [[ -n "$keys" ]]; then
    osascript <<EOF
tell application "iTerm"
    tell current session of (window id $WIN_ID)
        write text "$keys" newline NO
    end tell
end tell
EOF
    sleep 1
fi

# Width of the window in points, to know the scale of the display
WIN_W=$(osascript <<EOF
tell application "iTerm"
    set b to bounds of (window id $WIN_ID)
    return (item 3 of b) - (item 1 of b)
end tell
EOF
)

# Capture screenshot
if [[ $shadow ]]; then
    osascript <<EOF
tell application "iTerm"
    set newWin to (window id $WIN_ID)
    delay 0.3
    do shell script "screencapture -l " & (id of newWin) & " $OUTPUT"
    close newWin
end tell
EOF
else
    osascript <<EOF
tell application "iTerm"
    set newWin to (window id $WIN_ID)
    delay 0.3

    set winBounds to bounds of newWin
    set x1 to item 1 of winBounds
    set y1 to item 2 of winBounds
    set x2 to item 3 of winBounds
    set y2 to item 4 of winBounds
    set w to x2 - x1
    set h to y2 - y1

    do shell script "screencapture -R" & x1 & "," & y1 & "," & w & "," & h & " $OUTPUT"
    close newWin
end tell
EOF
fi

# On a Retina display the image has 2 pixels for a point (the shadow
# makes it a little wider than the window): reduce it to 1.
if [[ -f "$OUTPUT" && ! $hires && $WIN_W -gt 0 ]]; then
    px=$(sips -g pixelWidth "$OUTPUT" | awk '/pixelWidth/ { print $2 }')
    scale=$(( px / WIN_W ))
    if (( scale > 1 )); then
        sips --resampleWidth $(( px / scale )) "$OUTPUT" > /dev/null
    fi
fi

if [ -f "$OUTPUT" ]; then
    echo "Screenshot saved: $OUTPUT"
    ls -la "$OUTPUT"
else
    echo "Failed to create screenshot" >&2
    exit 1
fi
