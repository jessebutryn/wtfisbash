# Functions

This section contains a list of functions that I have found useful.  Most of these live in my `.bashrc` file but some are common
additions to the scripts that I write.


## Table of Contents

- [Functions](#functions)
  * [err](#err)
  * [yorn_ask](#yorn_ask)
  * [ascii](#ascii)
  * [factorial](#factorial)
  * [gitacp](#gitacp)
  * [gman](#gman)
  * [go](#go)
  * [mac_notify](#mac_notify)
  * [smash](#smash)
  * [weather](#weather)
  * [Return](#return)

---

## err

This is a standard error function that will send output to STDOUT and prepend it with the date/time the error occurred.
Additionally this function allows for the `-e` argument which will interpret control escape sequences to allow better formatting
of error messages.

``` bash
err () {
	local bld=$(tput bold)
	local rst="$(tput sgr0)"
	if [[ "$1" == '-e' ]]; then
		shift
		echo -e "${bld}[$(date +'%Y%m%dT%H%M%S%Z')]: $* ${rst}" >&2
	else
		echo "${bld}[$(date +'%Y%m%dT%H%M%S%Z')]: $* ${rst}" >&2
	fi
}
```

---

## yorn_ask

This function asks a question and requires the response be y or n.  It will keep asking until the user responds with a correct value.

```bash
yorn_ask () {
	local _r
	read -rp "$* [Y/n]: " _r
	until [[ ${_r,,} == y || ${_r,,} == n ]]; do
		printf '%s\n' "Please respond only with y or n"
		read -rp "$* [Y/n]: " _r
	done
	if [[ ${_r,,} == y ]]; then
		return 0
	else
		return 1
	fi
}
```

---

## ascii

This is a silly function that prints out some ascii art and automatically copies it to your clipboard.

``` bash
ascii () {
	while (( $# )); do
		case $1 in
			fliptable)
				printf '%s' '(╯°□°）╯︵ ┻━┻' | pbcopy
				pbpaste && echo
			;;
			unfliptable)
				printf '%s' '┬─┬ノ( º _ ºノ)' | pbcopy
				pbpaste && echo
			;;
			shrug)
				printf '%s' '¯\_(ツ)_/¯' | pbcopy
				pbpaste && echo
			;;
			joyent)
				printf '%s' "   __        .                   .
 _|  |_      | .-. .  . .-. :--. |-
|_    _|     ;|   ||  |(.-' |  | |
  |__|   \`--'  \`-' \`;-| \`-' '  ' \`-'
                   /  ;
                   \`-'" | pbcopy
				pbpaste && echo
			;;
			*)
				echo "Unsupported argument"
			;;
		esac
		shift
	done
}
```

---

## factorial

This is a simple function I created while messing with recursion that will calculate the factorial of a given number.

``` bash
factorial () {
	local num=$1
	if ((num==1)); then
		echo '1'
		return
	fi
	local n1=$((num-1))
	local f=$(factorial "$n1")
	local res=$((f*num))
	echo "$res"
}
```

---

## gitacp

This function will perform the `git add`, `git commit`, and `git push` commands in one step.  It will prompt you for
your commit message.

``` bash
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
```

---

## gman

The gman function will check your local system for man pages first, but if they are not found it will then
use `googler` to search the internet for the man page.

``` bash
gman () {
	local this_command="$1"
	( which -s "$this_command" ) || echo "ERROR! $this_command does not exist"
	( man "$this_command" 2>/dev/null ) || googler "$this_command" "man page"
}
```

---

## go

go is a function that stores a list of my commonly accessed directories and can be used to quickly navigate to them.

``` bash
go () {
	declare -A local goARR=(
		[tools]='/Users/jessebutryn/Documents/scripts/shell/NOCTools'
		[tmp]='/Users/jessebutryn/tmp'
		[wtf]='/Users/jessebutryn/Documents/Reference/wtfisbash'
		[pics]='/Users/jessebutryn/Pictures'
		[scripts]='/Users/jessebutryn/Documents/scripts'
		[training]='/Users/jessebutryn/Documents/Projects/Training'
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
			*)			echo "$1 is not a valid go option"; return 1;;
		esac
		shopt -u nocasematch
	fi
}
```

---

## mac_notify

This is a function for macos that will display a pop-up message to your system with customizable okay and cancel buttons.

``` bash
mac_notify () {
	local okay
	local cancel
	local message
	while (( $# )); do
		case $1 in
			-o) shift; okay=$1;;
			-c) shift; cancel=$1;;
			*)	message=$*;break;;
		esac
		shift
	done
	osascript <<-EOF
		set theDialogText to "${message:-"Alert!"}"
		display dialog theDialogText buttons {"${cancel:-Cancel}", "${okay:-Okay}"} default button "${okay:-Okay}" cancel button "${cancel:-Cancel}"
	EOF
}
```

---

## smash

This is a function I use frequently to kill stubborn processes.

``` bash
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
```

---

## weather

The weather function will query wttr.in for a weather report in your terminal.  It takes a zip code as an argument

``` bash
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
		curl -Ss "wttr.in/${w_zip}?0"
	fi
}
```

---

### Return
[Go back](./README.md)