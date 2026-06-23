# Set the title of the current tmux pane.
# Usage: tp <title>
# Works with: set -g pane-border-format " #{pane_title} "
function tp() { printf '\033]2;%s\033\\' "$1"; }
