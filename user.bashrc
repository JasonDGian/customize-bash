
#
# ~/.bashrc
#

#DO NOT TOUCH THIS.
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias rekde="systemctl --user restart plasma-plasmashell"
alias msv='ssh jaydee@192.168.1.130'
alias msfs="sshfs jaydee@192.168.1.130:/var/sftp/shared /home/jaydee/Desktop/Server"

# -- [REQUIRES - Figlet]
# Root user warning function.
# This function prints a sentence on screen
iamroot(){
echo -e "\033[;31;40;05m"
figlet "I AM ROOT"
echo -e "\033[00;00m PROCCEED WITH CAUTION, MORTAL..."
echo ""
}


# -- [REQUIRES - Nerd-fonts, Git]
# Function to retrieve and display the current branch's upstream branch in a Git repository.
# This function performs the following:
# 1. Retrieves the name of the upstream branch associated with the current local directory.
# 2. If an upstream branch is configured, the function formats and displays a styled message including the upstream branch name.
#    - The message is presented with custom colors and formatting.
# 3. If no upstream branch is configured for the current branch, no output is produced.
git_remote(){

	local remote_branch
	local remote_branch_truncated

    remote_branch=$(git for-each-ref --format '%(upstream:short)' $(git symbolic-ref -q HEAD 2> /dev/null) 2> /dev/null)

	remote_branch_truncated="${remote_branch:0:25}"

	if (( ${#remote_branch} > ${#remote_branch_truncated} )); then
		remote_branch="${remote_branch_truncated}"
	fi


	if [ -n "${remote_branch}" ]; then
		echo -e "\033[22;00;32;45m\033[48;2;220;110;110m\033[48;2;220;110;110m\033[1;38;2;0;0;0m  (${remote_branch}) \033[49m\033[22;38;2;220;110;110m"
	fi
}


# -- [REQUIRES - Nerd-fonts, Git]
# Function to display information about the current Git branch in the local repository.
# It performs the following checks and outputs:
#
# 1. **No Local or Remote Branch**:
#    - If there is no local branch (current directory is not a Git repository) and no upstream remote branch is configured,
#      it outputs a preformatted prompt closing character ( a white FG and no BG '' symbol).
#
# 2. **Local Branch Present but No Remote Branch**:
#    - If a local branch is found but no upstream remote branch is configured,
#      it outputs a preformatted string showing the local branch name, formatted with specific colors.
#
# 3. **Local and Remote Branch Present**:
#    - If both a local branch and an upstream remote branch are configured,
#      it outputs a preformatted string showing the local branch name with specific colors for continuation.
git_local(){

	local branch="$(git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3)"

	local branch_truncated="${branch:0:25}"

	if (( ${#branch} > ${#branch_truncated} )); then
		branch="${branch_truncated}..."
	fi

		# If no local nor remote branch is detected.
	if [ -z "${branch}" ] && [ -z "$(git_remote)" ]; then
		echo -e "\e[00;37;00m"

		# If local is found but no remote.
	elif [ -n "${branch}" ] && [ -z "$(git_remote)" ]; then
		echo -e "\e[37;42m\033[1;38;2;0;0;0m  (${branch})\e[32;40m"

		# In any other case (both local and remote found).
	else
		echo -e "\e[37;42m\033[1;38;2;0;0;0m  (${branch})";
	fi
}

# --- NOT USED IN PROMPT ---
# -- [REQUIRES - Git]
# Function to Display the Top-Level Directory Name of a Git Repository
# This function retrieves and displays the name of the top-level directory of the current Git repository.
git_repo(){
	local repo="$(git rev-parse --show-toplevel 2> /dev/null | cut -d "/" -f5)"
	local repo_truncated="${repo:0:25}"

	if (( ${#repo} > ${#repo_truncated} )) ; then
		repo="${repo_truncated}..."
	fi
	[ -n "${repo}" ] && echo " (${repo})"

}

# -- [REQUIRES - cd command, printwd function]
# Custom 'change directory' Function to Enhance Directory Navigation
# This function overrides the default `cd` command to provide custom behavior.
# every time a directory change occurs.
cd() {
  # Call the original cd command
  command cd "$@"

  # Clear the screen and list directory contents
	clear
	printwd
	ls
}

# -- [REQUIRES - NA]
# Function to Print the Current Working Directory
# This function provides a visual indication of the current directory in the terminal.
printwd() {
	echo -e "\e[01;34;33m You are here: \e[00;36m$(pwd)\e[00m"
}


# User prompt variables.

# Displays a GREEN or RED ball depending on the last command exit status.
status_ball(){ if [ $? -eq 0 ]; then echo -e "🟢"; else echo -e "\e[31m🔴\e[00m"; fi }

custom-user-color(){
echo -e "\e[30;44m\e[01;37;44m"
}

custom-dir-color(){
echo -e "\e[00;34;47m\e[01;37;43m"
}

dir-git-separator(){
echo -e "\e[00;33;47m"
}

color-reset(){
echo -e "\e[00m"
}

PS1='$(status_ball)$(custom-user-color)\u@\h$(custom-dir-color) \w $(dir-git-separator)$(git_local)$(git_remote)$(color-reset) \$ ▶ '

PS2="\[\e[30;41m\]\[\e[1;37;41m\]Type \[\e[00;31m\] \[\e[33m\]"

# ROOT PROMPT
# -------------------------------------------------------
#PS1='$(if [ $? -eq 0 ]; then echo 🟢; else echo \[\e[31m\]🔴\[\e[00m\]; fi)\[\e[30;41m\]\[\033[01;37;41;5m\] \u\[\e[0m\]\[\033[01;37;41m\]@\h \[\e[00;31;47m\]\[\033[01;37;43m\]\w \[\e[00;33;47m\]\[\e[37m\]\[\e[00m\]\[\e[00m\] \$ » '

#PS2="\[\e[30;41m\]\[\033[01;37;41m\]Type as root \[\e[00;31;47m\]\[\033[01;37m\]\[\e[00m\]\[\e[00m\] » "


# \[\e[fuerza;capa;color;r;g;b\]
# \[\e[1;38;2;0;0;0m\] -> negrita, texto, color 24 bits.
# \[\e[22;48;2;0;0;0m\] -> texto normal, fondo, color 24 bits.


# Blue background with black text. - \[\e[30;44m\] -> Reverted.\[\e[34;40m\]

#Quick Reference for Colors

#   Black: Text - 30, Background - 40
#   Red: Text - 31, Background - 41
#   Green: Text - 32, Background - 42
#   Yellow: Text - 33, Background - 43
#   Blue: Text - 34, Background - 44
#   Magenta: Text - 35, Background - 45
#   Cyan: Text - 36, Background - 46
#   White: Text - 37, Background - 47

# black 	- \[\e[30m\]
# blue 		- \[\e[30m\]
# cyan 		- \[\e[36m\]
# white 	- \[\e[37m\]
# green		- \[\e[32m\]
# yellow 	- \[\e[33m\]
# red  		- \[\e[31m\]
# magenta 	- \[\e[35m\]

# reset color  	- \[\e[00m\]

## Este comando hace que se invoque la orden al lanzar una instancia de la consola de este perfil.
