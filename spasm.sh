#/bin/sh -ex
#TODO reorganize whole file
DATA="$HOME/.local/share/spasm" #TODO look into a way of improving this to fit more systems. XDG_DATA_HOME maybe?

OPT_ADD=
OPT_GET=

cat=""
name=""
pass=""

#TODO include all program options
#TODO improve formatting and readability
usage(){ 
	echo "usage: spasm [ -h ] [ -G length | -p password ] [ -a [category]/[name] ] [ -g [category]/[name] ] [ -d [category/name] ]"
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

#TODO implement file encryption
add_pass(){
	[ -z "$pass" ] && echo "invalid argument -- -a requires password" && explode
	[ -f "$DATA/$cat/$name" ] && echo "password for \"$name\" already exists" && explode
	mkdir -p "$DATA/$cat" && echo "adding password: $pass to $cat/$name" && echo $pass > "$DATA/$cat/$name"
}

#TODO implement decrypting password file
get_pass(){
	[ ! -f "$DATA/$cat/$name" ] && echo "invalid argument -- no such category or password" && explode || cat "$DATA/$cat/$name" 
}

# parses if the path was typed correctly: "category/service"
parse_path(){
	#TODO check if theres a better/faster way to do this check.
	local control="$1"
	cat=$(echo $1 | cut -d"/" -f1)
	name=$(echo $1 | cut -d"/" -f2)
	
	if [ ! $control = "$cat/$name" ]; then 
		echo "invalid argument -- path should be passed like: [category]/[name]"
		explode 
	fi
}

delete_pass(){
	[ ! -f "$DATA/$1" ] && echo "invalid argument -- no such category or password" && explode
	rm -rf "$DATA/$1"
	[ ! "$(ls -A "$DATA/$cat")" ] && rmdir "$DATA/$cat"
}

optstring="hG:p:a:g:d:"
while getopts $optstring FLAG; #TODO add handling for no options passed
do	
	case $FLAG in	
	h) usage && exit 0 ;;
	G) [ -n "$pass" ] && explode || pass=$(gen_pass $OPTARG) ;;#TODO add proper error messages
	p) [ -n "$pass" ] && explode || pass=${OPTARG} ;;#TODO add proper error messages
	a) parse_path $OPTARG && OPT_ADD=true ;;
	g) parse_path $OPTARG && OPT_GET=true ;; 
	d) parse_path $OPTARG && delete_pass $OPTARG ;;

	\?) usage; exit 1 ;;
	esac
done

[ $OPT_ADD ] && add_pass
[ $OPT_GET ] && get_pass

exit 0
