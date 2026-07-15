#!/bin/zsh

# WSL: bridge Linux ssh/git to the Windows OpenSSH Authentication Agent
if [[ -n ${WSL_DISTRO_NAME:-} ]]; then
	command -v socat >/dev/null  || echo "WSL ssh-agent: sudo apt install socat"
	command -v unzip >/dev/null || echo "WSL ssh-agent: sudo apt install unzip"
	_npiperelay_dir="$HOME/.local/share/wsl-ssh-agent"
	_npiperelay="$_npiperelay_dir/npiperelay.exe"
	if [[ ! -x $_npiperelay ]]; then
		mkdir -p "$_npiperelay_dir"
		_zip="$(mktemp)"
		if curl -fsSL -o "$_zip" \
			https://github.com/jstarks/npiperelay/releases/download/v0.1.0/npiperelay_windows_amd64.zip \
			&& unzip -oj "$_zip" npiperelay.exe -d "$_npiperelay_dir" \
			&& chmod +x "$_npiperelay"; then
			echo "installed $_npiperelay"
		else
			echo "failed to install npiperelay.exe"
		fi
		rm -f "$_zip"
	fi
	rm -f "$HOME/.local/bin/npiperelay.exe"
	unset _npiperelay _npiperelay_dir _zip
fi

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
