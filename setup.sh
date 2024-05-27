#!/bin/zsh

# Make links for all files to dotfiles folder
for file in $(realpath $(dirname $0))/**/.*; do # Everything starting with dot
	if [[ -d $file ]]; then # Skip directories
		continue
	fi
	echo                                          $(realpath --relative-to=$(realpath $(dirname $0)) $file)
	mkdir -p                          ~/$(dirname $(realpath --relative-to=$(realpath $(dirname $0)) $file))
	ln -s $(realpath --relative-to=$HOME $file) ~/$(realpath --relative-to=$(realpath $(dirname $0)) $file)
done
