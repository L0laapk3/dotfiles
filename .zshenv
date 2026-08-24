#! /bin/env zsh

export TZ=Europe/Brussels

# Use the locally managed ssh-agent, but never override an agent forwarded in over
# ssh -- that one belongs to the machine we came from.
_ssh_agent_sock="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"
if [[ -z ${SSH_AUTH_SOCK:-} && -S $_ssh_agent_sock ]]; then
	export SSH_AUTH_SOCK="$_ssh_agent_sock"
fi
unset _ssh_agent_sock

hash -d C=/mnt/c

[[ -r ~/.zshenv.local ]] && source ~/.zshenv.local
