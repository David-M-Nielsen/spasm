#/bin/sh -ex

DATA="$HOME/.local/share/spasm/" #TODO look into a way of improving this

cat=""
name=""
pass=""

#TODO include all program options
usage(){ 
	echo "usage: spasm [-h] [-G length | -p password] [-a category/service] [-g category/service]"
}

gen_pass() {
	#TODO Overhaul to include special characters and follow OWASP
	< /dev/urandom tr -dc A-Za-z0-9 | head -c$1; echo # Temporary. 
}

# test if category exists, create it if it does not
schrodinger(){
	echo "schrodinger: $DATA$cat"
	mkdir -p "$DATA$cat/"
}

# TODO impl. creating an encrypted file with the password innit
make_pass(){
	echo "creating password: $pass"
}

# parses if the path was typed correctly: "category/website"
parse_path(){
	echo "parse_path"
	# TODO check if theres a better/faster way to do this check.
	cat=$(echo $1 | cut -d"/" -f1)
	name=$(echo $1 | cut -d"/" -f2)

	if [[ ! "$1" = "$cat/$name" ]]; then
		echo "invalid argument -- target should be passed like: [category]/[service]"
		usage
		exit 1
	fi
}


optstring="hG:p:a:g:"
#TODO find a way to ensure checking order
while getopts $optstring FLAG; #TODO add handling for no options passed
do	
	case $FLAG in	
	h) usage; exit 0 ;; # prints help
	G) [[ -n "$pass" ]] && usage || pass=$(gen_pass $OPTARG) ;; #generates password
	p) [[ -n "$pass" ]] && usage || pass=${OPTARG} ;; #takes password from user

	# supposed to add a new password. 
	# TODO needs to varify file structure "category/website" and needs either G or p to work.
	a) parse_path $OPTARG && schrodinger && [[ ! -z $pass ]] && make_pass ;;

	# Error handling
	\?) usage; exit 1 ;;

	esac
done
