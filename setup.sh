#!/bin/zsh

dstDir=${1:-$HOME}
srcDir=${2:-$(dirname $0)}

# Make links for all files to dotfiles folder
for file in "$srcDir"/**/.*; do # Everything starting with dot
	if [[ -d "$file" ]]; then # Skip directories
		continue
	fi
	src=$(realpath --relative-to="$dstDir" "$file")
	dst=$(realpath --relative-to="$srcDir" "$file")
	mkdir -p $(dirname ~/"$dst")
	result=""
	if [[ -L ~/"$dst" ]]; then
		rm ~/"$dst"
		result="(replaced)"
	fi
	if [[ -e ~/"$dst" ]]; then
		result="(exists)"
	else
		ln -s ~/"$src" ~/"$dst"
	fi

	printf "~/%-19s -> ~/%-28s %s\n" "$dst" "$src" $result
done
