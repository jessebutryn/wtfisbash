# .bash_profile
# Author:  Jesse Butryn <jesse.butryn>
#
#####################################
# Changelog
#####################################
#
# 12-07-2017	-	Initial draft.
#
#####################################
# Table of Contents
#####################################
#
# 1) Colors
# 2) Begin
# 3) Environmental Variables
# 4) Information
# 5) Other
#
#####################################
# Section 1: Colors
#####################################
TXT_BLD=$(tput bold)
TXT_RED=$(tput setaf 1)
TXT_GRN=$(tput setaf 2)
TXT_YLW=$(tput setaf 3)
TXT_BLU=$(tput setaf 4)
TXT_MAG=$(tput setaf 5)
TXT_CYN=$(tput setaf 6)
TXT_GOOD="${TXT_BLD}${TXT_GRN}"
TXT_WARN="${TXT_BLD}${TXT_YLW}"
TXT_FAIL="${TXT_BLD}${TXT_RED}"
TXT_RST=$(tput sgr0)
#####################################
# Section 2: Begin
#####################################
clear
echo -e "==========Loading ${TXT_GOOD}bash_profile${TXT_RST}=========="
#####################################
# Section 3: Environmental Variables
#####################################
### SYSTEM ###
export NVM_DIR=/Users/jessebutryn/.nvm
export EXTERNAL_IP="$(curl --connect-timeout 5 -m 15 -Ss ipinfo.io/ip)"
export CURR_SSID="$(airport -I | awk '$1~/^SSID:/{print $0}' | tr -d " " | awk -F: '{print $2}')"
export CURR_DAY="$(date +%a)"
### PERSONAL ###
export SSH_INPUT='/Users/jessebutryn/tools/.nodeinput.csv'
if [[ "$CURR_SSID" == "Joyent5" ]]; then
	export MAC_LOCATION='work'
elif [[ "$CURR_SSID" == "ITBurnsWhenIP5" ]]; then
	export MAC_LOCATION='home'
else
	export MAC_LOCATION='other'
fi
#####################################
# Section 4: Information
#####################################
#CPU_USAGE="$(top -l 2 | awk '/CPU usage/{print $3+$5,$7/1}')"
#MEM_USAGE="$(top -l 2 | awk '/PhysMem/{print $2, $6}')"
case $MAC_LOCATION in
	work)
		curl --connect-timeout 5 -m 15 -Ss "wttr.in/80127" | tail -n +2 | head -n 6
		echo -e "\t${TXT_WARN}Littleton, CO${TXT_RST}\n"
		echo -e "Location:\t${TXT_FAIL}WORK${TXT_RST} | Hostname:\t${TXT_BLD}$(hostname)${TXT_RST} | Date:\t${TXT_BLD}$(date "+%m/%d/%Y %H:%M")${TXT_RST}" | column -t
	;;
	home)
		curl --connect-timeout 5 -m 15 -Ss "wttr.in/80123" | tail -n +2 | head -n 6
		echo -e "\t${TXT_GOOD}Littleton, CO${TXT_RST}\n"
		echo -e "Location:\t${TXT_GOOD}HOME${TXT_RST} | Hostname:\t${TXT_BLD}$(hostname)${TXT_RST} | Date:\t${TXT_BLD}$(date "+%m/%d/%Y %H:%M")${TXT_RST}" | column -t
	;;
	*)	echo -e "${TXT_FAIL}Where the hell are you?${TXT_RST}";;
esac
printf '%*s\n' "${COLUMNS:-$(tput cols)}" | tr ' ' .
case $CURR_DAY in
	Sun)	echo -e "\t\t\t\tSunday:\n\t\t${TXT_FAIL}Don't work on your day off.${TXT_RST}"
		echo "${TXT_BLD}$(fortune -o)${TXT_RST}"
		;;
	Mon)	echo -e "\t\t\t\tMonday:\n\t\t${TXT_FAIL}Don't work on your day off.${TXT_RST}"
		echo "${TXT_BLD}$(fortune -o)${TXT_RST}"
		;;
	Tue)	echo -e "\t\t\t\tTuesday:\n\t\t${TXT_FAIL}Don't work on your day off.${TXT_RST}"
		echo "${TXT_BLD}$(fortune -o)${TXT_RST}"
		;;
	Wed)	echo -e "\t\t\t\tWednesday:\n\t\t${TXT_FAIL}Oh shit...just starting${TXT_RST}"
		echo "${TXT_BLD}$(fortune)${TXT_RST}"
		;;
	Thu)	echo -e "\t\t\t\tThursday:\n\t\t${TXT_WARN}Everything will break today, bet.${TXT_RST}"
		echo "${TXT_BLD}$(fortune)${TXT_RST}"
		;;
	Fri)	echo -e "\t\t\t\tFriday:\n\t\t${TXT_WARN}Almost there...wtf is node.js?${TXT_RST}"
		echo "${TXT_BLD}$(fortune)${TXT_RST}"
		;;
	Sat)	echo -e "\t\t\t\tSaturday:\n\t\t${TXT_GOOD}This is it...don't burn the place down!${TXT_RST}"
		echo "${TXT_BLD}$(fortune)${TXT_RST}"
		;;
esac
printf '%*s\n' "${COLUMNS:-$(tput cols)}" | tr ' ' .
echo "History on today's date:"
awk -v td="$(date '+%m/%d')" '$1 == td' /usr/share/calendar/calendar.history
printf '%*s\n' "${COLUMNS:-$(tput cols)}" | tr ' ' .
echo -e "Network:\t${TXT_WARN}$CURR_SSID${TXT_RST} | Channel:\t${TXT_BLD}$(airport -I | awk '/channel/{print $NF}')${TXT_RST} | External IP:\t${TXT_BLD}$EXTERNAL_IP${TXT_RST}" | column -t
printf '%*s\n' "${COLUMNS:-$(tput cols)}" | tr ' ' .
#echo -e "CPU (Used/Free):\t${TXT_FAIL}$(echo $CPU_USAGE | awk '{print $1"%"}')${TXT_RST}/${TXT_GOOD}$(echo $CPU_USAGE | awk '{print $2"%"}')${TXT_RST}"
#echo -e "Memory (Used/Free):\t${TXT_FAIL}$(echo $MEM_USAGE	| awk '{print $1}')${TXT_RST}/${TXT_GOOD}$(echo $MEM_USAGE | awk '{print $2}')${TXT_RST}"
#####################################
# Section 5: Source files
#####################################
[[ -f ~/.bashrc ]] && source ~/.bashrc
[[ $PRIVATERC_RUN != yes && -f ~/.privaterc ]] && source ~/.privaterc
echo
export PATH="$HOME/.cargo/bin:$PATH"
