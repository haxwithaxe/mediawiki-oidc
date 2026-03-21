ARG VERSION=1.44

FROM mediawiki:${VERSION}

ARG EXTENSION_BRANCH="REL1_45"

WORKDIR /var/www/html
COPY ./composer.local.json composer.local.json
RUN apt-get update && apt-get install -y unzip zip jq
RUN git clone --depth 1 --branch $EXTENSION_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/PluggableAuth /var/www/html/extensions/PluggableAuth
RUN git clone --depth 1 --branch $EXTENSION_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/OpenIDConnect /var/www/html/extensions/OpenIDConnect
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN  jq 'del(.. | .["require-dev"]?)' vendor/composer.lock > vendor-composer.lock.tmp \
	&& mv vendor-composer.lock.tmp vendor/composer.lock \
	&& jq 'del(.. | .["require-dev"]?)' vendor/composer.json > vendor-composer.json.tmp \
	&& mv vendor-composer.json.tmp vendor/composer.json \
	&& jq 'del(.. | .["require-dev"]?)' composer.json > composer.json.tmp \
	&& mv composer.json.tmp composer.json
RUN php composer-setup.php && rm composer-setup.php && php composer.phar install -n --no-dev
