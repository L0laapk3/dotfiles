#! /bin/env zsh

export TZ=Europe/Brussels

# WSL: expose Windows ssh-agent to Linux ssh/git via SSH_AUTH_SOCK. Only adopt a
# relay that is already up; starting one lives in .zprofile, because .zshenv runs
# for every non-interactive zsh too and must stay fork-free.
if [[ -n ${WSL_DISTRO_NAME:-} && -z ${SSH_AUTH_SOCK:-} ]]; then
	_wsl_ssh_agent_sock="${XDG_RUNTIME_DIR:-$HOME/.ssh}/wsl-ssh-agent.sock"
	[[ -S $_wsl_ssh_agent_sock ]] && export SSH_AUTH_SOCK="$_wsl_ssh_agent_sock"
	unset _wsl_ssh_agent_sock
fi

hash -d C=/mnt/c

[[ -r ~/.zshenv.local ]] && source ~/.zshenv.local
