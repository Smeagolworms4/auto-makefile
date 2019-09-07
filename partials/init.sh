#/bin/bash

LIST="php phpmyadmin mysql mailhog nginx node";

bold=$(tput bold)
normal=$(tput sgr0)

SELECT=""
printSelected() {
	[ "${VALUES[$2]}" = "1" ] && TEXT="[X] $1" || TEXT="[ ] $1"
	[ "$2" = "$SELECTED" ] && TEXT=" -> $bold$TEXT$normal" || TEXT="    $TEXT"
	[ "${VALUES[$2]}" = "1" ] && TEXT="\033[0;32m$TEXT\033[0m"
	echo -e "$TEXT"
}

clearLine() {
	tput cuu1;tput el;
}

clearLines() {
	for I in `seq 1 $1`; do clearLine; done
}
_key() {
	local kp
	local _KEY=; IFS=''; read -rsn1 _KEY
	case $_KEY in
		"") _KEY=ENTER ;;
		$'\x09') _KEY=TAB ;;
		$'\x7f') _KEY=BACKSPACE ;;
		$'\x20') _KEY=SPACE ;;
		$'\e')
			while read -d '' -sn1 -t1 kp; do
				_KEY=$_KEY$kp
				case $kp in
					[a-zA-NP-Z~]) break;;
				esac
			done
			case $_KEY in
				$'\e[11~' | $'\e[OP') _KEY2=F1 ;;
				$'\e[12~' | $'\e[OQ') _KEY2=F2 ;;
				$'\e[13~' | $'\e[OR') _KEY2=F3 ;;
				$'\e[14~' | $'\e[OS') _KEY2=F4 ;;
				$'\e[15~') _KEY=F5 ;;
				$'\e[16~') _KEY=F6 ;;
				$'\e[17~') _KEY=F7 ;;
				$'\e[18~') _KEY=F8 ;;
				$'\e[19~') _KEY=F9 ;;
				$'\e[20~') _KEY=F10 ;;
				$'\e[21~') _KEY=F11 ;;
				$'\e[22~') _KEY=F12 ;;
				$'\e[A' ) _KEY=UP ;;
				$'\e[B' ) _KEY=DOWN ;;
				$'\e[C' ) _KEY=RIGHT ;;
				$'\e[D' ) _KEY=LEFT ;;
			esac
		;;
	esac
	unset IFS
	printf -v "${1:-_KEY}" "%s" "$_KEY"
}

echo ""
echo "######################"
echo "# Initialize project #"
echo "######################"
echo ""
printf "DOCKER_NAME (Must be alpha-lowercase ex: projectname): "
read -r DOCKER_NAME 
printf "BASE_URL (ex: mydomaine.com): "
read -r BASE_URL 

LIST_AR=($LIST)
COUNT=0; for name in $LIST; do COUNT=`expr $COUNT + 1`; done
KEY=""
SELECTED=0
declare -A VALUES
while [ "$KEY" != "ENTER" ]; do
	echo "Select your project dependencies:"
	echo ""
	for i in ${!LIST_AR[@]}; do
		printSelected ${LIST_AR[$i]} $i
	done
	echo ""
	echo "Press space for check and enter for valid"
	_key KEY
	case $KEY in
		"UP") SELECTED=$(expr $SELECTED - 1); [ $SELECTED = -1 ] && SELECTED=$(expr $COUNT - 1) ;;
		"DOWN") SELECTED=$(expr $SELECTED + 1); [ $SELECTED = $COUNT ] && SELECTED=0 ;;
		"RIGHT"|"SPACE") [ "${VALUES[$SELECTED]}" = 1 ] && VALUES[$SELECTED]=0 || VALUES[$SELECTED]=1 ;;
	esac
	if [ "$KEY" != "ENTER" ]; then clearLines `expr $COUNT + 4`; fi
done

RESULT=""
for i in ${!LIST_AR[@]}; do
	if [ "${VALUES[$i]}" = "1" ]; then 
		RESULT="$RESULT "${LIST_AR[$i]}""
	fi
done

echo ""
echo "Creation of your project:"
echo "    use dependencies: $RESULT"
echo ""

####################
# Create make file #
####################
echo -e "\
export DOCKER_NAME=projectname\n\
export BASE_URL=projectdomaine.com\n\
export MAKEFILES=\"$RESULT\"\n\
\n\
" > Makefile
if [ "$2" = "1" ]; then
echo -e "\
export MAKEFILE_BASE_URL=$1\n\
\n\
" >> Makefile
fi
echo -e "\
#####################\n\
# External resource #\n\
#####################\n\
\$(shell [ ! -f docker/.makefiles/root ] && mkdir -p docker/.makefiles && curl -L --silent -f $1/root -o docker/.makefiles/root) \n\
include docker/.makefiles/root\n\
\n\
" >> Makefile
