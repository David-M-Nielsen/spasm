#/bin/sh

ROOT="$home/.local/spasm/"
optstring="hG:p:"

usage(){ printf "usage: spasm [-h] [-G length | -p password]"; }

gen_pass() {
	< /dev/urandom tr -dc A-Za-z0-9 | head -c$1; echo # Temporary. Overhaul to include special characters and follow OWASP
}



while getopts $optstring arg; do
	case ${arg} in
		
		# Usable args
		h)	usage ;;
		G)	[[ -n "$PASS" ]] && usage || PASS=$(gen_pass $OPTARG) ;;
		p)	[[ -n "$PASS" ]] && usage || PASS=${OPTARG} ;;
	
		# Error handling
		\?)	printf "invalid argument -- $OPTARG" 1>&2; usage ;;
		:)	printf "argument needed to -$OPTARG" 1>&2; usage ;;
		*) usage ;;
	esac
done

echo $PASS
