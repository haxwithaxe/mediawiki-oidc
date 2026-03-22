#!/bin/sh

strip_require_dev() {
	jq 'del(.. | .["require-dev"]?)' "$1" > composer.thing.tmp
	mv composer.thing.tmp "$1"
}

add_security_exception() {
	jq '.config.audit.ignore |= {"'$2'": "'$3'"}' "$1" > composer.thing.tmp 
	mv composer.thing.tmp "$1"
}

for thing in \
	vendor/composer.json \
	vendor/composer.lock \
	skins/*/composer.json \
	extensions/*/composer.json
	do 
		strip_require_dev "$thing"
		add_security_exception "$thing" "PKSA-y2cr-5h3j-g3ys" "Not a real vuln. A lib is not responsible for people abusing it."
		add_security_exception "$thing" "PKSA-z3gr-8qht-p93v" "Dev requirement not used in production"
done
