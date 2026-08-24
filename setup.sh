#!/bin/zsh

srcDir=$(realpath --relative-to="$HOME" "${1:-$(dirname $0)}")
dstDir=$(realpath --relative-to="$HOME" "${2:-$HOME}")

# echo "~/$dstDir -> ~/$srcDir"

# Make links for all files to dotfiles folder
for file in $(find "$HOME/$srcDir" -xtype f -wholename "$HOME/$srcDir/.*" -not -path "$HOME/$srcDir/.git/*" -and -not -path "$HOME/$srcDir/dotfiles/*"); do # Everything starting with dot

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
		ln -s "$(realpath -s -m --relative-to="$(dirname "$src")" "$srcDir")/$(realpath -s --relative-to="$HOME/$dstDir" "$HOME/$src")" "$HOME/$dst"
		printf "~/%-23s -> ~/%-32s %s\n" "$dst" "$src" $result
	fi

done


# WSL: activate the ssh-agent unit just linked. Only WSL needs a locally managed
# agent; everywhere else it arrives forwarded over ssh. daemon-reload is still
# allowed to fail, since a WSL distro without systemd=true has no user instance.
if [[ -n $WSL_DISTRO_NAME ]] && systemctl --user daemon-reload 2>/dev/null; then
	systemctl --user enable ssh-agent.service >/dev/null 2>&1
	if ! systemctl --user is-active --quiet ssh-agent.service; then
		systemctl --user start ssh-agent.service && echo "started ssh-agent.service"
	fi
fi
