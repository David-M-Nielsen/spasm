#/bin/sh -ex

ROOT="~/.local/share/spasm/"
pass_cat=""
pass=""

optstring="hG:p:a:"

usage(){ 
	echo "usage: spasm [-h] [-G length | -p password]"
}

gen_pass() {
	< /dev/urandom tr -dc A-Za-z0-9 | head -c$1; echo # Temporary. Overhaul to include special characters and follow OWASP
}

# test if category exists
schrodinger(){
	local cat=$(echo $1 | cut -d"/" -f1)
	local dir="$ROOT$cat"
	echo $dir
	mkdir -p $dir
}

while getopts $optstring FLAG; 
do	
	case $FLAG in	
		h) usage; exit 0 ;; # prints help
		G) [[ -n "$pass" ]] && usage || pass=$(gen_pass $OPTARG) ;; #generates password
		p) [[ -n "$pass" ]] && usage || pass=${OPTARG} ;; #takes password from user
		a) schrodinger $OPTARG ;;
		# Error handling
		\?) usage; exit 1 ;;
	esac
done

#temporary output for test purposes
#echo $PASS
