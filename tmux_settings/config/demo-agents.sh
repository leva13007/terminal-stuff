#!/usr/bin/env bash
# Live-demo launcher: N Claude Code agents in parallel tmux panes,
# each on its own git worktree/branch. See notes/04-multi-agent-demo.md.
#
# Usage: ./demo-agents.sh   (run from inside the target git repo)
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
SESSION="agents-demo"
TASKS=("agent-1:auth-refactor" "agent-2:add-tests" "agent-3:update-docs")

tmux kill-session -t "$SESSION" 2>/dev/null || true

for task in "${TASKS[@]}"; do
  name="${task%%:*}"
  branch="${task##*:}"
  worktree="${REPO_ROOT}-${name}"
  git -C "$REPO_ROOT" worktree add "$worktree" -b "$branch" 2>/dev/null || true
done

tmux new-session -d -s "$SESSION" -c "${REPO_ROOT}-agent-1"
tmux split-window -h -t "$SESSION" -c "${REPO_ROOT}-agent-2"
tmux split-window -v -t "$SESSION" -c "${REPO_ROOT}-agent-3"
tmux select-layout -t "$SESSION" tiled

tmux send-keys -t "$SESSION.0" 'tp "agent-1: auth"; claude' C-m
tmux send-keys -t "$SESSION.1" 'tp "agent-2: tests"; claude' C-m
tmux send-keys -t "$SESSION.2" 'tp "agent-3: docs"; claude' C-m

tmux attach -t "$SESSION"
