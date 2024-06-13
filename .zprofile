#! /bin/env zsh

export LUSER=$LFOLDER/$USER
if ! [[ -d $LFOLDER ]]; then
    link_local() {
    	echo "ERROR: '$LFOLDER' does not exist! Cannot link local folders from user."
	}
else
    # Create /localdev/$USER/$USER, only if /localdev exists
    mkdir -p $LUSER

    # Creates folder inside $LUSER and links from user to there
    link_local() {
        mkdir -p $LUSER/$1
        ln -sfT $LUSER/$1 ~/$1
    }
fi

export DEFAULT_USER=$USER
