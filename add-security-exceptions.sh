#!/bin/sh

set -e

add_security_exception() {
	set -x
	jq '.config.audit.ignore += {"'"$2"'": "'"$3"'"}' "$1" > composer.thing.tmp 
	set +x
	mv composer.thing.tmp "$1"
}

add_security_exception composer.json "PKSA-y2cr-5h3j-g3ys" "Not a real vuln. A lib is not responsible for people abusing it."
add_security_exception composer.json "PKSA-z3gr-8qht-p93v" "Dev requirement not used in production"
