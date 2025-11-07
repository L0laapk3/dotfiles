#! /bin/env zsh

export PATH=$HOME/.local/bin:$PATH

export PYTHONPATH="$HOME/pythonpath:$PYTHONPATH"

# fly.io
export FLYCTL_INSTALL="/home/kris/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

chmod -f go-r ~/.z