#!/bin/bash

. resources/constants
. resources/colors

#------------GLOBAL_VARS & CONSTANTS-----------
readonly DIST=$(echo $(uname -v) | cut -d" " -f3)
readonly BASH_FILE=`[[ "$DIST" == "Debian" ]] && echo "$HOME/.bash_profiles" || echo "$HOME/.bashrc"`

#--------------------USER----------------------
printf "%b" "You are $BGreen$(whoami)$Coloroff under $BYellow$DIST$Coloroff distribution are you sure yo want to continue? y/n " 
read response
if [ $response == 'y' ]; then 
	: 
else
	exit 0
fi

#---------------COMMON FUNCTIONS --------------
append_to_file () {
	if [ ! -f "$2" ]
	then
		touch "$2"
	fi

	local string_exists=$( grep "$1" $2 ) 
	if [ -z "$string_exists" ] 
	then
		echo "$1" >> $2
		echo "$3 DONE"
	else
		echo "$3 already done"
	fi
}

#-----UPDATE UPGRADE AND INSTALL PACKAGES------
sudo chmod +x ./dependencies.sh
./dependencies.sh

#--------------------TMUX----------------------
echo "----------TMUX---------"
def_tmux='if [[ -z "$TMUX" ]]; then
	if tmux has-session 2>/dev/null; then
		exec tmux attach
	else
		exec tmux
	fi
fi'
append_to_file "$def_tmux" $BASH_FILE "Automatically init tmux when open terminal"

cp .tmux.conf $HOME/.tmux.conf

#---------------------GIT----------------------
cp .gitconfig $HOME/.gitconfig

