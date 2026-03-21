#!/bin/sh

strip_require_dev() {
	jq 'del(.. | .["require-dev"]?)' "$1" > composer.thing.tmp
	mv composer.thing.tmp "$1"
	rm composer.thing.tmp
}

for thing in \
	vendor/composer.json \
	vendor/composer.lock \
	skins/*/composer.json \
	skins/*/composer.lock \
	extensions/*/composer.json \
	extensions/*/composer.lock
	do 
	strip_require_dev "$thing"
done
