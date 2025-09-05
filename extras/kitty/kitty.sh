#!/usr/bin/env bash

KITTY_CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
cp -f ./extras/kitty/*.py "$KITTY_CONFIG_PATH/"
