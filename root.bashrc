#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
#PS1='[\u@\h \W]\$'


# -- [REQUIRES - Figlet]
# Root user warning function.
# This function prints a sentence on screen
iamroot(){
echo -e "\033[;31;40;05m"
figlet "I AM ROOT"
echo -e "\033[00;00m PROCCEED WITH CAUTION, MORTAL..."
echo ""
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

# Normal prompt customization.
PS1='$(
if [ $? -eq 0 ]; then echo -e "🟢"; else echo -e "\[\e[31m\]🔴\[\e[00m\]"; fi
)\[\e[30;41m\]\[\e[01;37;41;5m\] \u\[\e[00m\]\[\e[01;37;41m\]@\h \[\e[00;31;47m\]\[\e[01;37;43m\] \w \[\e[00;33;47m\]$(
	branch="$(git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3)"

	branch_truncated="${branch:0:25}"

	if (( ${#branch} > ${#branch_truncated} )); then
		branch="${branch_truncated}..."
	fi

		# If no local nor remote branch is detected.
	if [ -z "${branch}" ] && [ -z "$(git_remote)" ]; then
		echo -e "\[\e[00;37;00m\]"

		# If local is found but no remote.
	elif [ -n "${branch}" ] && [ -z "$(git_remote)" ]; then
		echo -e "\[\e[37;42m\]\[\033[1;38;2;0;0;0m\]  (${branch})\[\e[32;40m\]"

		# In any other case (both local and remote found).
	else
		echo -e "\[\e[37;42m\]\[\033[1;38;2;0;0;0m\]  (${branch})";
	fi
)$(

    remote_branch=$(git for-each-ref --format "%(upstream:short)" $(git symbolic-ref -q HEAD 2> /dev/null) 2> /dev/null)

	remote_branch_truncated="${remote_branch:0:25}"

	if (( ${#remote_branch} > ${#remote_branch_truncated} )); then
		remote_branch="${remote_branch_truncated}"
	fi


	if [ -n "${remote_branch}" ]; then
		echo -e "\[\033[22;00;32;45m\]\[\033[48;2;220;110;110m\]\[\033[48;2;220;110;110m\]\[\033[1;38;2;0;0;0m\]  (${remote_branch}) \[\033[49m\]\[\033[22;38;2;220;110;110m\]"
	fi
) \[\e[00m\] » \[\e[5 q\]'

# "Typing" prompt customization.
PS2="\[\e[30;41m\]\[\033[01;37;41m\]Type as root \[\e[00;31;47m\]\[\033[01;37m\]\[\e[00m\]\[\e[00m\] » "

# Comment or erase this line to deactivate the I AM ROOT warning figlet.
iamroot
