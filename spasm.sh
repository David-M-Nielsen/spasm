#/bin/sh -ex
#TODO reorganize whole file
DATA="$HOME/.local/share/spasm/" #TODO look into a way of improving this to fit more systems. XDG_DATA_HOME maybe?

OPT_ADD=
OPT_GET=

cat=""
name=""
pass=""

#TODO include all program options
#TODO improve formatting and readability
usage(){ 
	echo "usage: spasm [-h] [-G length | -p password] [-a category/service] [-g category/service]"
}

explode(){
	usage && exit 1
}

#TODO implement this
make_backup()(
	echo "creating backup..."
	#cp $DATA spasm.bak
)

#TODO implement restoring from a .bak file
restore_backup(){
	echo "restoring from .bak file"
}

gen_pass() {
	#TODO Overhaul to include special characters and follow OWASP
	< /dev/urandom tr -dc A-Za-z0-9 | head -c$1; echo # Temporary. 
}

# test if category exists and creates it if it does not. Checks if password exists and returns true if it does #TODO add password checking
schrodinger(){
	echo "entering schrodinger with: $DATA$cat"
	mkdir -p "$DATA$cat/"
	return 0 #TODO change to reflect whether or not password exists
}

#TODO impl. creating an encrypted file with the password innit
add_pass(){	
	[[ -z "$pass" ]] && echo "invalid argument -- -a requires password" && explode
	schrodinger && echo "name \"$name\" already exists" && explode || echo "adding password: $pass to $cat/$name"
}

#TODO implement getting and decrypting password from file
get_pass(){
	schrodinger && echo "getting password from: $DATA$cat/$name"
}

# parses if the path was typed correctly: "category/website"
parse_path(){
	echo "entering parse_path with arg: $1"
	#TODO check if theres a better/faster way to do this check.
	cat=$(echo $1 | cut -d"/" -f1)
	name=$(echo $1 | cut -d"/" -f2)

	if [[ ! "$1" = "$cat/$name" ]]; then
		echo "invalid argument -- path should be passed like: [category]/[service]"
		explode
	fi
}

optstring="hG:p:a:g:"
while getopts $optstring FLAG; #TODO add handling for no options passed
do	
	case $FLAG in	
	h) usage; exit 0 ;; # prints help
	G) [[ -n "$pass" ]] && explode || pass=$(gen_pass $OPTARG) ;; #generates password #TODO add proper error messages
	p) [[ -n "$pass" ]] && explode || pass=${OPTARG} ;; #takes password from user #TODO add proper error messages

	a) parse_path $OPTARG && OPT_ADD=true ;; #sets option for adding new password to true
	g) parse_path $OPTARG && OPT_GET=true ;; #sets option for getting password to true
	# Error handling
	\?) usage; exit 1 ;;

	esac
done

[ $OPT_ADD ] && add_pass

if [ $OPT_GET ]; then
	get_pass
fi

#TODO remove cleanup stuff

rmdir $DATA$cat
