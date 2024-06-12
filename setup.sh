#!/bin/zsh

srcDir=$(realpath --relative-to="$HOME" "${1:-$(dirname $0)}")
dstDir=$(realpath --relative-to="$HOME" "${2:-$HOME}")

# echo "~/$dstDir -> ~/$srcDir"

# Make links for all files to dotfiles folder
for file in $(find "$HOME/$srcDir" -xtype f -name '.*' -not -path "$HOME/$srcDir/.git" -and -not -path "$HOME/$srcDir/dotfiles/*"); do # Everything starting with dot

	file=$(realpath -s --relative-to="$HOME/$srcDir" "$file")

	if [[ "$file" == ".gitmodules" ]]; then
		continue
	fi

	src="$srcDir/$file"
	dst=$(realpath -s --relative-to="$HOME" "$HOME/$dstDir/$file")

	mkdir -p $(dirname "$HOME/$dst")
	result=""
	if [[ -L "$HOME/$dst" ]]; then
		rm "$HOME/$dst"
		result="(link updated)"
	fi
	if [[ -e "$HOME/$dst" ]]; then
		result="(file exists)"
	else
		ln -s "$(realpath --relative-to="$HOME/$dstDir" "$HOME/$src")" "$HOME/$dst"
		printf "~/%-23s -> ~/%-32s %s\n" "$dst" "$src" $result
	fi

done
