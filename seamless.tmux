#!/usr/bin/env bash

SEAMLESS_REPO_DIR=$(dirname "$0")
tmux source-file "$SEAMLESS_REPO_DIR/extras/tmux/pane_keybindings.conf"
