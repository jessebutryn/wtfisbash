# .bashrc
# Author:  Jesse Butryn <jesse.butryn>
#
###########################
# Start
###########################
echo -e "==========Loading ${TXT_FAIL}bashrc${TXT_RST}=========="
###########################
# Sourcing files
###########################
[[ -s "${NVM_DIR}/nvm.sh" ]] && \. "${NVM_DIR}/nvm.sh"  # This loads nvm
[[ -s "${NVM_DIR}/bash_completion" ]] && \. "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion
###########################
# Shell variables
###########################

###########################
# Functions
###########################
yorn.ask () {
    read -p "$@ [Y/n]: " RESP && local YORN_RESP="$(echo "${RESP:0:1}" | grep -i "[YN]")"
	while [[ -z "$YORN_RESP" ]]; do
		echo "Please respond only with: y or n"
		read -p "$@ [Y/n]: " RESP && local YORN_RESP="$(echo "${RESP:0:1}" | grep -i "[YN]")"
	done
	[[ "$YORN_RESP" == 'Y' || "$YORN_RESP" == 'y' ]] && return 0 || return 1
}
jpc-manta () {
	export MANTA_URL='https://us-east.manta.joyent.com'
	export MANTA_USER="$JPC_MANTA_USER"
	echo -e "Manta set to:\tJPC East"
}
spc-manta-east () {
	export MANTA_URL="$SPC_EAST_MURL"
	export MANTA_USER="$SPC_MANTA_USER"
	echo -e "Manta set to:\tSPC East"
}
spc-manta-central () {
	export MANTA_URL="$SPC_CENTRAL_MURL"
	export MANTA_USER="$SPC_MANTA_USER"
	echo -e "Manta set to:\tSPC Central"
}
spc-manta-southeast () {
	export MANTA_URL="$SPC_SE_MURL"
	export MANTA_USER="$SPC_MANTA_USER"
	echo -e "Manta set to:\tSPC Southeast"
}
go () {
	declare -A local goARR=(
		[tools]='/Users/jessebutryn/tools'
		[tmp]='/Users/jessebutryn/tmp'
		[wtf]='/Users/jessebutryn/Documents/Reference/wtfisbash'
		[pics]='/Users/jessebutryn/Pictures'
		[scripts]='/Users/jessebutryn/Documents/scripts'
		[training]='/Users/jessebutryn/Documents/Projects/Training'
		[noc]='/Users/jessebutryn/tools/joyent/NOCTools'
	)
	PS3='Select a directory: '
	if [[ -z "$1" ]]; then
		echo "Where do you want to go?"
		select index in "${!goARR[@]}" Exit; do
			case "$index" in
				Exit)
					echo "Goodbye"
					return 0 && break 2
					;;
				*)
					cd "${goARR[$index]}"
					break
					;;
			esac
		done
	else
		shopt -s nocasematch
		case "$1" in
			tools) 		cd "${goARR[tools]}";;
			tmp|temp) 	cd "${goARR[tmp]}";;
			wtf*)		cd "${goARR[wtf]}";;
			pic*)		cd "${goARR[pics]}";;
			scripts)	cd "${goARR[scripts]}";;
			training)	cd "${goARR[training]}";;
			noc)		cd "${goARR[noc]}";;
			*)			echo "$1 is not a valid go option"; return 1;;
		esac
		shopt -u nocasematch
	fi
}
smash () {
	local T_PROC="$1"
	local T_PIDS=($(pgrep -i "$T_PROC"))
	if [[ "${#T_PIDS[@]}" -ge 1 ]]; then
		echo "Found the following processes:"
		for pid in "${T_PIDS[@]}"; do
			echo "$pid" "$(ps -p "$pid" -o comm= | awk -F'/' '{print $NF}')" | column -t
		done
		if ( yorn.ask "Kill them?" ); then
			for pid in "${T_PIDS[@]}"; do
				echo "Killing ${pid}..."
				( kill -15 "$pid" ) && continue
				sleep 2
				( kill -2 "$pid" ) && continue
				sleep 2
				( kill -1 "$pid" ) && continue
				echo "What the hell is this thing?" >&2 && return 1
			done
		else
			echo "Exiting..."
			return 0
		fi
	else
		echo "No processes found for: $1" >&2 && return 1
	fi
}
gitacp () {
	if [[ -z "$1" ]]; then
		echo "ERROR! You must specify a file to add, commit, and push."
	else
		declare -a GIT_FILES+=("$@")
	fi
	for file in "${GIT_FILES[@]}"; do
		git add "$file" && continue
		echo "Failed to add $file"
	done
	git diff --stat --cached
	echo
	read -rp "What is your commit message? " GIT_COMMIT
	echo
	if ( git commit -m "$GIT_COMMIT" ); then
		git push || echo "Error! Failed to push."
	else
		echo "Error! Failed to commit."
	fi
}
gman () {
	local this_command="$1"
	( which -s "$this_command" ) || echo "ERROR! $this_command does not exist"
	( man "$this_command" 2>/dev/null ) || googler "$this_command" "man page"
}
weather () {
	local w_opts=
	local w_zip=
	while (( $# )); do
		case $1 in
			-a)
				local w_opts=ALL
			;;
			[0-9][0-9][0-9][0-9][0-9])
				local w_zip=$1
			;;
			*)
				echo "ERROR! Unknown option: $1"
				exit 1
			;;
		esac
		shift
	done
	if [[ -z "$w_zip" ]]; then
		case $MAC_LOCATION in
			work) w_zip=80127;;
			home) w_zip=80123;;
			*)
				echo "ERROR! I don't know where you want the weather for."
				exit 1
			;;
		esac
	fi
	if [[ "$w_opts" == ALL ]]; then
		curl -Ss "wttr.in/${w_zip}"
	else
		curl -Ss "wttr.in/${w_zip}" | tail -n +2 | head -n 6
	fi
}
###########################
# Aliases
###########################
alias cls='clear'
alias ll='ls -laghFG'
alias l='ls -laghFG'
alias xcode='open -a xcode'
alias text='open -a Atom'
alias pre='open -a Preview'
alias cd..='cd ..'
alias reload='source ~/.bash_profile'
alias bj='~/Documents/scripts/shell/games/blackjack.bash'
alias spc-manta-se='spc-manta-southeast'
alias billchk='/usr/local/NOCTools/noc-billchk'
alias cmdb='/usr/local/NOCTools/noc-cmdb'
alias cnapi='/usr/local/NOCTools/noc-cnapi'
alias convert='/usr/local/NOCTools/noc-convert'
alias mshare='/usr/local/NOCTools/noc-mshare'
alias mtest='/usr/local/NOCTools/noc-mtest'
alias sshnode='/usr/local/NOCTools/noc-sshnode'
alias vmapi='/usr/local/NOCTools/noc-vmapi'
alias vpn='/usr/local/NOCTools/noc-vpn'
alias zuora='/usr/local/NOCTools/noc-zuora'
alias opschk='/Users/jessebutryn/tools/personal/opschk'
alias man='gman'
alias yum='brew'
###########################
# Prompt Config
###########################
export PS1="\[$(tput bold)\]♕ \[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;76m\]\u\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;9m\]\h\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\] ♕\[$(tput sgr0)\] [\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;208m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]]\n{\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;226m\]\$?\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]} \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;33m\]➔\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
###########################
# Apps that mess with my
# path are annoying
###########################
PATH=/usr/local/NOCTools:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/jessebutryn/.nvm/versions/node/v6.11.5
export PATH