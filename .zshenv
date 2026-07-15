#! /bin/env zsh

export TZ=Europe/Brussels

# WSL: expose Windows ssh-agent to Linux ssh/git via SSH_AUTH_SOCK.
if [[ -n ${WSL_DISTRO_NAME:-} ]]; then
	_wsl_ssh_agent_sock="${XDG_RUNTIME_DIR:-$HOME/.ssh}/wsl-ssh-agent.sock"
	_npiperelay="$HOME/.local/share/wsl-ssh-agent/npiperelay.exe"

	_wsl_ssh_agent_alive() {
		[[ -S $_wsl_ssh_agent_sock ]] || return 1
		SSH_AUTH_SOCK="$_wsl_ssh_agent_sock" ssh-add -l &>/dev/null
		(( $? < 2 ))
	}

	if ! _wsl_ssh_agent_alive && command -v socat >/dev/null && [[ -x $_npiperelay ]]; then
		pkill -f "socat UNIX-LISTEN:$_wsl_ssh_agent_sock," 2>/dev/null
		rm -f "$_wsl_ssh_agent_sock"
		setsid socat "UNIX-LISTEN:$_wsl_ssh_agent_sock,fork" \
			"EXEC:$_npiperelay -ei -s //./pipe/openssh-ssh-agent,nofork" \
			>/dev/null 2>&1 &
		for _i in {1..40}; do
			_wsl_ssh_agent_alive && break
			sleep 0.05
		done
	fi

	_wsl_ssh_agent_alive && export SSH_AUTH_SOCK="$_wsl_ssh_agent_sock"

	unset _wsl_ssh_agent_sock _npiperelay _i
	unfunction _wsl_ssh_agent_alive 2>/dev/null
fi

[[ -r ~/.zshenv.local ]] && source ~/.zshenv.local
