#! /bin/env zsh

export TZ=Europe/Brussels

# WSL runs its own ssh-agent (.config/systemd/user/ssh-agent.service); adopt its
# socket, but never override an agent forwarded in over ssh -- that one belongs to
# the machine we came from.
if [[ -n $WSL_DISTRO_NAME && -z $SSH_AUTH_SOCK ]]; then
	_ssh_agent_sock="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"
	[[ -S $_ssh_agent_sock ]] && export SSH_AUTH_SOCK="$_ssh_agent_sock"
	unset _ssh_agent_sock
fi

hash -d C=/mnt/c

[[ -r ~/.zshenv.local ]] && source ~/.zshenv.local
