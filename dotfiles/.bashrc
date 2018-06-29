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
[[ -f /usr/local/bin/proutes.sh ]] && \. /usr/local/bin/proutes.sh &>/dev/null
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
spc-manta-northeast () {
	export MANTA_URL="$SPC_NE_MURL"
	export MANTA_USER="$SPC_MANTA_USER"
	echo -e "Manta set to:\tSPC Northeast"
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
	if [[ -z $1 ]]; then
		echo "Where do you want to go?"
		select index in "${!goARR[@]}" Exit; do
			case $index in
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
		case $1 in
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
	local T_PROC=$1
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
	if [[ -z $1 ]]; then
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
	local this_command=$1
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
	if [[ -z $w_zip ]]; then
		case $MAC_LOCATION in
			work) w_zip=80127;;
			home) w_zip=80123;;
			*)
				echo "ERROR! I don't know where you want the weather for."
				return 1
			;;
		esac
	fi
	if [[ "$w_opts" == ALL ]]; then
		curl -Ss "wttr.in/${w_zip}"
	else
		curl -Ss "wttr.in/${w_zip}" | tail -n +2 | head -n 6
	fi
}
mac.notify () {
	local okay
	local cancel
	local message
	while (( $# )); do
		case $1 in
			-o) shift; okay=$1;;
			-c) shift; cancel=$1;;
			*)	message=$@;break;;
		esac
		shift
	done
	osascript <<EOF
		set theDialogText to "${message:-"Alert!"}"
		display dialog theDialogText buttons {"${cancel:-Cancel}", "${okay:-Okay}"} default button "${okay:-Okay}" cancel button "${cancel:-Cancel}"
EOF
}
my.prompt () {
	local prompt=$1
	case $prompt in
		simple)
			export PS1="\u \W \\$ "
		;;
		default)
			export PS1="[\[$(tput bold)\]\[\033[38;5;2m\]$(get.batt)\[$(tput sgr0)\]]\[$(tput bold)\]:\[$(tput sgr0)\][\[$(tput bold)\]\[\033[38;5;2m\]\w\[$(tput sgr0)\]]\[$(tput bold)\]:\[$(tput sgr0)\]{\[$(tput bold)\]\[\033[38;5;11m\]\$?\[$(tput sgr0)\]}\n\[$(tput bold)\]\\$\[$(tput sgr0)\] "
		;;
		nocolor)
			export PS1="[$(get.batt)]:[\w]:{\$?}\n\\$ \[$(tput sgr0)\]"
		;;
		*)
			export PS1='\h:\W \u\$ '
		;;
	esac
}
math () {
	while (( $# )); do
		case $1 in
			scale)
				shift
				local scale=$1
				shift
			;;
			*)
				local equation=$@
				shift $#
			;;
		esac
	done
	if [[ -n $scale ]]; then
		bc<<<"scale=$scale; $equation"
	else
		bc<<<"$equation"
	fi
}
dict () {
	less < <(
		curl -s "dict://dict.org/d:$@" \
		| egrep -v '^220|^221|^250|^150' \
		| sed $'s/^151/-------------------------------\\\n/g'
		)
}
ascii () {
	while (( $# )); do
		case $1 in
			fliptable)
				echo '(╯°□°）╯︵ ┻━┻'
			;;
			shrug)
				echo '¯\_(ツ)_/¯'
			;;
			joyent)
				echo "   __        .                   .
 _|  |_      | .-. .  . .-. :--. |-
|_    _|     ;|   ||  |(.-' |  | |
  |__|   \`--'  \`-' \`;-| \`-' '  ' \`-'
                   /  ;
                   \`-'"
			;;
			*)
				echo "Unsupported argument"
			;;
		esac
		shift
	done
}
get.batt () {
	local barray=($(pmset -g batt | tail -1 | awk '{print $3/1"%",$4,$5}'))
	#local barray=($(awk '{print $3/1"%",$4,$5}' <<<"$batt"))
	if [[ ${barray[1]/;/} == 'discharging' ]]; then
		echo "${TXT_FAIL}${barray[0]}${TXT_RST}-${barray[2]/(no/)}"
	else
		echo "${TXT_GOOD}${barray[0]}${TXT_RST}"
	fi
}
flip () {
	echo "$@" | /Users/jessebutryn/tools/personal/flip.pl
}
###########################
# Aliases
###########################
#for util in /usr/local/bin/g*; do
#	if [[ -f $util ]]; then
#		aname=$(basename "$util")
#		alias "${aname#g}"="$util"
#	fi
#done
alias cls='clear'
alias c='clear'
alias ll='ls -laghFG'
alias l='ls -laghFG'
alias xcode='open -a xcode'
alias text='open -a Atom'
alias pre='open -a Preview'
alias cd..='cd ..'
alias reload='source ~/.bash_profile'
alias spc-manta-se='spc-manta-southeast'
alias spc-manta-ne='spc-manta-northeast'
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
alias notify='/usr/local/NOCTools/noc-notify'
alias opschk='/Users/jessebutryn/tools/personal/opschk'
alias merika='/Users/jessebutryn/tools/personal/merika'
alias innit='/Users/jessebutryn/tools/personal/innit'
alias man='gman'
alias yum='brew'
alias vnc='open "/Applications/Remote Desktop - VNC.app"'
alias ls='/usr/local/bin/gls --color'
###########################
# Prompt Config
###########################
my.prompt default
###########################
# Apps that mess with my
# path are annoying
###########################
PATH=/usr/local/NOCTools:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/jessebutryn/.nvm/versions/node/v6.11.5
export PATH