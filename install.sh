#!/bin/bash

colreset="\e[0m"
answRequest="Please answer with \e[1;32m'Y'\e[00m or \e[1;31m'N'\e[00m"
splitLine="----------------------------------------------------------------------"

function warnMsg() {
    local input_string="$1" # Get the input string passed as the first argument
    local result="\e[01;33mWARNING:\e[0\e[00;33m $input_string\e[0m" # Create the new string with the>
    echo "$result" # Return the result string
}
function infoMsg() {
    local input_string="$1" # Get the input string passed as the first argument
    local result="\e[01;94mINFO:\e[0m\e[00;94m $input_string\e[0m" # Create the new string with the>
    echo "$result" # Return the result string
}
function errorMsg() {
    local input_string="$1" # Get the input string passed as the first argument
    local result="\e[01;31mERROR:\e[0\e[00;31m $input_string\e[0m" # Create the new string with the>
    echo "$result" # Return the result string
}
function confirmMsg(){
    local input_string="$1" # Get the input string passed as the first argument
    local result="\e[01;32m $input_string\e[0m" # Create the new string with the>
    echo "$result" # Return the result string
}
function noConfirmMsg(){
    local input_string="$1" # Get the input string passed as the first argument
    local result="\e[01;31m $input_string\e[0m" # Create the new string with the>
    echo "$result" # Return the result string
}

function makeProfile (){

# users can be root or can be the user.
local userDir=$1

# Files expected are .bashrc and .bash_profile
local file=$2

# Text that is introduced in the generated file.
local textFile=$3

echo "$splitLine"

if [ -f /$userDir/$file ]; then

    echo -e "$(warnMsg "Existing /$userDir/$file file detected. Creating a backup.")"

    if mv /$userDir/$file /$userDir/$file.bak; then

    echo -e "$(infoMsg "/$userDir/$file sucessfully backed up as /$userDir/$file.bak")"

    else
        echo -e "$(errorMsg "Failed to backup /$userDir/$file. Operation aborted.")"
        exit 1
    fi

else
    echo -e "$(infoMsg "No existing /$userDir/$file file detected.")"
fi

echo -e "$(infoMsg "Generating new /$userDir/$file")"

touch /$userDir/$file

# Write the new /$userDir/$file content
cat << EOF > /$userDir/$file
$textFile
EOF

echo "$splitLine"
}


function changeOwner(){

    local userDir="$1"
    local file="$2"
    local username="$3"

    # Change ownership of file.
    echo -e "$(infoMsg "Changing ownership of /$userDir/$file to owner $username")"

    if chown $username:$username /$userDir/$file; then
        echo -e "$(confirmMsg "Changes in ownsership to /$userDir/$file applied successfully.")"
    else
        echo -e "$(errorMsg "An error occurred while changing ownership of /$userDir/$file.")"
    fi
}

function changeAccessMode(){

    local userDir="$1"
    local file="$2"
    local permissions=644

    # Change ownership of file.
    echo -e "$(infoMsg "Changing access mode of /$userDir/$file to $permissions")"

    if chmod $permissions /$userDir/$file; then
        echo -e "$(confirmMsg "Changes in access mode to /$userDir/$file applied successfully.")"
    else
        echo -e "$(errorMsg "An error occurred while changing access mode of /$userDir/$file.")"
    fi
}

# - Check if the script run as root or sudo through Effective User ID.
if [ "$EUID" -ne 0 ]; then
  echo -e "$(errorMsg "The script must be run with sudo privileges or as root user.")"
  echo -e "Exiting programme."
  exit 1
fi

# Check if the script is being run with `sudo` by evaluating if `$SUDO_USER` is set.
# If `$SUDO_USER` is set, it assigns `$SUDO_USER` to the variable `username`.
# If `$SUDO_USER` is not set, it falls back to using `logname` to determine the current user and assigns this to `username`.
#
# Initialize `userConfirm` to 0 to start a loop that prompts the user for confirmation.
# The loop continues until the user provides a valid confirmation (`Y` or `N`):
# - If the user confirms with `Y` or `y`, it sets `userConfirm` to 1, ending the loop.
# - If the user declines with `N` or `n`, it prompts for a new username and repeats the confirmation process.
# - If the input is invalid, it asks the user to answer with `Y` or `N` and continues the loop.

echo "$splitLine"

if [ -n "$SUDO_USER" ]; then
    username=$SUDO_USER
    echo -e "$(infoMsg "Sudo invoker $username set as user.")"
else

    if [ -n "$(logname)" ]; then
        username=$(logname)
        echo -e "$(warnMsg "Failed to retrieve sudo invoker as user.")"
        echo -e "$(infoMsg "Logname user $username set as user instead.")"
    else
        echo -e "$(warnMsg "Failed to retrieve sudo invoker and logname user.")"
        echo -e "$(warnMsg "User must be specified manually")"
        echo -e "Enter username:"
        read username
    fi
fi

userConfirm=0

while [ $userConfirm = 0 ]; do

    echo -e "\e[1;95;00;00mCustomize prompt for user \e[94m'$username'\e[00m?"
    echo -e "$answRequest"

    read answer
    echo "$splitLine"
    case "$answer" in
        [Yy])
            echo -e "$(confirmMsg "User confirmed as $username.")"
            userConfirm=1
            ;;
        [Nn])
            echo -e "$(noConfirmMsg "User not confirmed. Falling back.")"
            echo -e "Enter new user:"
            read username
            ;;
        *)
            echo -e "$( errorMsg "Invalid input.\e[00m Please answer with \e[1;32m'Y'\e[00m or \e[1;31m'N'\e[00m.")"
            ;;
    esac
done

# Defining root bash_profile contents.
rootBashprofile=$(cat <<'EOF'
#
# ~/.bash_profile
#
# Customized by JasonDGian customization bash script.

[[ -f ~/.bashrc ]] && . ~/.bashrc
EOF
)

# Defining root bashrc contents.
rootBashrc=$(cat << 'EOF'
#
# ~/.bashrc
#
# Customized by JasonDGian customization bash script.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'


iamroot(){
echo -e "\033[;31;40;05m"
figlet "I AM ROOT"
echo -e "\033[00;00m PROCCEED WITH CAUTION, MORTAL..."
echo ""
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

git_local(){

	local branch="$(git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3)"
	local branch_truncated="${branch:0:25}"

	if (( ${#branch} > ${#branch_truncated} )); then
		branch="${branch_truncated}..."
	fi

	if [ -z "${branch}" ] && [ -z "$(git_remote)" ]; then
		echo -e "\e[00;37;00m"

	elif [ -n "${branch}" ] && [ -z "$(git_remote)" ]; then
		echo -e "\e[37;42m\033[1;38;2;0;0;0m  (${branch})\e\[32;40m"

	else
		echo -e "\e[37;42m\033[1;38;2;0;0;0m  (${branch})";
	fi
}

cd() {
  # Call the original cd command
  command cd "$@"

  # Clear the screen and list directory contents
	clear
	printwd
	ls
}

printwd() {
	echo -e "\e[01;34;33m You are here: \e[00;36m$(pwd)\e[00m"
}

status_ball(){ if [ $? -eq 0 ]; then echo -e "🟢"; else echo -e "\e[31m🔴\e[00m"; fi }

custom-root-color(){
echo -e "\e[30;41m\e[01;37;41;5m"
}

custom-hostname-color(){
echo -e "\e[01;37;41m"
}

custom-dir-color(){
echo -e "\e[00;31;47m\e[01;37;43m "
}

dir-git-separator(){
echo -e "\e[00;33;47m"
}

color-reset(){
echo -e "\e[00m"
}

PS1='$(status_ball)$(custom-root-color) \u$(color-reset)$(custom-hostname-color)@\h $(custom-dir-color)\w $(dir-git-separator)$(git_local)$(git_remote)$(color-reset) \$ » '

PS2="\[\e[30;41m\]\[\033[01;37;41m\]Type as root \[\e[00;31;47m\]\[\033[01;37m\]\[\e[00m\]\[\e[00m\] » "
EOF
)

## Call the make profile function for ROOT.
makeProfile "root" ".bash_profile" "$rootBashprofile"
makeProfile "root" ".bashrc" "$rootBashrc"


# ----------------------------------------------------------------------------------------
# User is prompted to decide to activate or deactivate the figlet warning for root logins.

figletConfirm=0

while [ $figletConfirm != 1 ]; do
    echo -e "Would you like to activate the figlet warning when login into root?"
    echo -e "$answRequest"

    read figletAnswer

    echo "$splitLine"
    case "$figletAnswer" in
        [Yy])
            echo -e "$(confirmMsg "Figlet root warning activated.")"
            echo "iamroot" >> /root/.bashrc
            figletConfirm=1
            ;;
        [Nn])
            echo -e "$(noConfirmMsg "Figlet root warning de-activated.")"
            figletConfirm=1
            ;;
        *)
            echo -e "$(errorMsg "Invalid input. $answRequest")"
            ;;
    esac
    echo "$splitLine"
done


userBashprofile=$(cat <<'EOF'
#
# ~/.bash_profile
#
# Customized by JasonDGian customization bash script.

[[ -f ~/.bashrc ]] && . ~/.bashrc
EOF
)

userBashrc=$(cat <<'EOF'
#
# ~/.bashrc
#
# Customized by JasonDGian customization bash script.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

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

git_local(){

	local branch="$(git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3)"
	local branch_truncated="${branch:0:25}"

	if (( ${#branch} > ${#branch_truncated} )); then
		branch="${branch_truncated}..."
	fi

	if [ -z "${branch}" ] && [ -z "$(git_remote)" ]; then
		echo -e "\e[00;37;00m"

	elif [ -n "${branch}" ] && [ -z "$(git_remote)" ]; then
		echo -e "\e[37;42m\033[1;38;2;0;0;0m  (${branch})\e[32;40m"
	else
		echo -e "\e[37;42m\033[1;38;2;0;0;0m  (${branch})";
	fi
}

cd() {
  command cd "$@"
	clear
	printwd
	ls
}

printwd() {
	echo -e "\e[01;34;33m You are here: \e[00;36m$(pwd)\e[00m"
}

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
EOF
)

makeProfile "home/$username" ".bash_profile" "$userBash_profile"
makeProfile "home/$username" ".bashrc" "$userBashrc"

# This section of the script is responsible for modifying the ownership and access

if [ -n "$username" ]; then

    changeOwner "home/$username" ".bash_profile" "$username"
    changeAccessMode "home/$username" ".bash_profile"

    changeOwner "home/$username" ".bashrc" "$username"
    changeAccessMode "home/$username" ".bashrc"

else
    echo -e "$(errorMsg "Username is not set or is empty.")"
fi

echo "$splitLine"

# Determine the Linux distribution
if [ -f /etc/debian_version ]; then
    # Debian-based
    sudo apt-get update
    sudo apt-get install -y git
    sudo apt-get install -y figlet
    sudo apt-get install -y nerd-fonts
elif [ -f /etc/redhat-release ]; then
    # Red Hat-based
    sudo yum check-update
    sudo yum install -y git
    sudo yum install -y figlet
    sudo yum install -y nerd-fonts
elif [ -f /etc/arch-release ]; then
    # Arch-based
    sudo pacman -Syu
    sudo pacman -S --noconfirm git
    sudo pacman -S --noconfirm  figlet
    sudo pacman -S --noconfirm  nerd-fonts
else
    echo "Dependencies cannot be installed through this script due to distribution."
    echo "Customization may present errors."
    echo "Please install git, figlet and nerd-fonts manually on your system."
    exit 1
fi

echo "$splitLine"
echo "DONE"
echo "$splitLine"

