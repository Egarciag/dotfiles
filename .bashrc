#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'

# Aliases 
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi


# Bash Options
shopt -s cdspell
shopt -s checkwinsize
shopt -s histappend
shopt -s cmdhist
shopt -s extglob
shopt -s no_empty_cmd_completion

# Bash History
export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE='&:[ ]*:bg:fg:ls:ll:la:cd:exit:x:clear:c:history:h'
HISTTIMEFORMAT='%D %a %T  '

# Colored MAN Pages
if $_isxrunning; then
	export PAGER=less
	export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
	export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
	export LESS_TERMCAP_me=$'\E[0m'           # end mode
	export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
	export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
	export LESS_TERMCAP_ue=$'\E[0m'           # end underline
	export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
fi

# Priviliged Acces
if ! $_isroot; then
	alias reboot='sudo reboot'
	alias halt='sudo halt'
fi

# Navigate Directories
up() {
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++)); do
		d=$d/..
	done
	d=$(echo $d | sed 's/^\///')
	if [[ -z "$d" ]]; then
		d=..
	fi
	cd $d
}

# Extract
extract() {
	clrstart="\033[1;34m"  # color codes
	clrend="\033[0m"

	if [[ "$#" -lt 1 ]]; then
		echo -e "${clrstart}Pass a filename. Optionally a destination folder. You can also append a v for verbose output.${clrend}"
		exit 1 # not enough args
	fi

	if [[ ! -e "$1" ]]; then
		echo -e "${clrstart}File does not exist!${clrend}"
		exit 2 # file not found
	fi

	if [[ -z "$2" ]]; then
		DESTDIR="." # set destdir to current dir
	elif [[ ! -d "$2" ]]; then
		echo -e -n "${clrstart}Destination folder doesn't exist or isnt a directory. Create? (y/n): ${clrend}"
		read response
		#echo -e "\n"
		if [[ $response == y || $response == Y ]]; then
			mkdir -p "$2"
			if [ $? -eq 0 ]; then
				DESTDIR="$2"
			else
				exit 6 # Write perms error
			fi
		else
			echo -e "${clrstart}Closing.${clrend}"; exit 3 # n/wrong response
		fi
	else
		DESTDIR="$2"
	fi

	if [[ ! -z "$3" ]]; then
		if [[ "$3" != "v" ]]; then
			echo -e "${clrstart}Wrong argument $3 !${clrend}"
			exit 4 # wrong arg 3
		fi
	fi

	filename=`basename "$1"`

	# echo "${filename##*.}" debug

	case "${filename##*.}" in
		tar)
			echo -e "${clrstart}Extracting $1 to $DESTDIR: (uncompressed tar)${clrend}"
			tar x${3}f "$1" -C "$DESTDIR"
			;;
		gz)
			echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
			tar x${3}fz "$1" -C "$DESTDIR"
			;;
		tgz)
			echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
			tar x${3}fz "$1" -C "$DESTDIR"
			;;
		xz)
			echo -e "${clrstart}Extracting  $1 to $DESTDIR: (gip compressed tar)${clrend}"
			tar x${3}f -J "$1" -C "$DESTDIR"
			;;
		bz2)
			echo -e "${clrstart}Extracting $1 to $DESTDIR: (bzip compressed tar)${clrend}"
			tar x${3}fj "$1" -C "$DESTDIR"
			;;
		zip)
			echo -e "${clrstart}Extracting $1 to $DESTDIR: (zipp compressed file)${clrend}"
			unzip "$1" -d "$DESTDIR"
			;;
		rar)
			echo -e "${clrstart}Extracting $1 to $DESTDIR: (rar compressed file)${clrend}"
			unrar x "$1" "$DESTDIR"
			;;
		7z)
			echo -e  "${clrstart}Extracting $1 to $DESTDIR: (7zip compressed file)${clrend}"
			7za e "$1" -o"$DESTDIR"
			;;
		*)
			echo -e "${clrstart}Unknown archieve format!"
			exit 5
			;;
	esac
}

# Remind Me
remindme() { sleep $1 && zenity --info --text "$2" & }

PS1='[\u@\h \W]\$ '
