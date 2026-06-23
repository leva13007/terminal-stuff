# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A YouTube learning project about tmux — config, keybindings, sessions, panes. The hands-on experience here becomes video content. Part of the `~/projects/` management layer; see the root `CLAUDE.md` for overall project rules.

## Structure

```
config/
  tmux.conf              # main tmux configuration
  zshrc-additions.zsh    # shell functions that pair with the tmux config (e.g. tp)
notes/                   # per-topic markdown notes → raw material for video scripts
```

## Working with the Config

The config file is at `config/tmux.conf`. To test it against a live tmux session:

```bash
tmux source-file /path/to/config/tmux.conf
```

From inside tmux: `prefix + :` → `source-file /path/to/config/tmux.conf`

To see all currently active options:

```bash
tmux show-options -g
```
