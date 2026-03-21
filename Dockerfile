ARG VERSION=1.44

FROM mediawiki:${VERSION}

ARG EXTENSION_BRANCH="REL1_45"

WORKDIR /var/www/html
COPY ./composer.local.json composer.local.json
RUN apt-get update && apt-get install unzip zip jq
RUN git clone --depth 1 --branch $EXTENSION_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/PluggableAuth /var/www/html/extensions/PluggableAuth
RUN git clone --depth 1 --branch $EXTENSION_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/OpenIDConnect /var/www/html/extensions/OpenIDConnect
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN  jq 'del(.. | .["require-dev"]?)' vendor/composer.lock > composer.lock.tmp && mv composer.lock.tmp vendor/composer.lock
RUN php composer-setup.php && rm composer-setup.php && php composer.phar install -n --no-dev
