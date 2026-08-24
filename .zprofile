#! /bin/env zsh

# export LUSER=$LFOLDER/$USER
# if ! [[ -d $LFOLDER ]]; then
#     link_local() {
#     	echo "ERROR: '$LFOLDER' does not exist! Cannot link local folders from user."
# 	}
# else
#     # Create /localdev/$USER/$USER, only if /localdev exists
#     mkdir -p $LUSER
#
#     # Creates folder inside $LUSER and links from user to there
#     link_local() {
#         mkdir -p $LUSER/$1
#         ln -sfT $LUSER/$1 ~/$1
#     }
# fi

export DEFAULT_USER=$USER

# WSL: bridge Linux ssh/git to the Windows OpenSSH agent via socat + npiperelay.
if [[ -n ${WSL_DISTRO_NAME:-} ]]; then
	_wsl_ssh_agent_sock="${XDG_RUNTIME_DIR:-$HOME/.ssh}/wsl-ssh-agent.sock"
	_npiperelay="$HOME/.local/share/wsl-ssh-agent/npiperelay.exe"

	# A relay whose Windows end is down still accepts connect() and then never
	# replies, so the probe needs a hard deadline: an unbounded ssh-add wedges the
	# shell for good, and before p10k's instant prompt can report anything.
	_wsl_ssh_agent_alive() {
		[[ -S $_wsl_ssh_agent_sock ]] || return 1
		SSH_AUTH_SOCK="$_wsl_ssh_agent_sock" timeout 2 ssh-add -l &>/dev/null
		(( $? < 2 ))
	}

	# Only spawn a relay when there is demonstrably none: killing a live socat
	# races the other shells that WSL starts at the same time, and an unresponsive
	# relay means the Windows-side agent is down, which respawning cannot fix.
	if ! _wsl_ssh_agent_alive && command -v socat >/dev/null && [[ -x $_npiperelay ]] &&
		! pgrep -u "$USER" -f "socat UNIX-LISTEN:$_wsl_ssh_agent_sock," >/dev/null 2>&1; then
		mkdir -p "${_wsl_ssh_agent_sock:h}"
		rm -f "$_wsl_ssh_agent_sock"
		setsid socat "UNIX-LISTEN:$_wsl_ssh_agent_sock,fork" \
			"EXEC:$_npiperelay -ei -s //./pipe/openssh-ssh-agent,nofork" \
			>/dev/null 2>&1 &
		# Wait for the socket to appear, nothing more; probing per iteration would
		# multiply the deadline above by the iteration count.
		for _i in {1..40}; do
			[[ -S $_wsl_ssh_agent_sock ]] && break
			sleep 0.05
		done
	fi

	_wsl_ssh_agent_alive && export SSH_AUTH_SOCK="$_wsl_ssh_agent_sock"

	unset _wsl_ssh_agent_sock _npiperelay _i
	unfunction _wsl_ssh_agent_alive 2>/dev/null
fi

[[ -r ~/.zprofile.local ]] && source ~/.zprofile.local

