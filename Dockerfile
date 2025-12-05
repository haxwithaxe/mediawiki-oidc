ARG VERSION=1.44

FROM mediawiki:${VERSION}

ARG EXTENSION_BRANCH="REL1_44"

WORKDIR /var/www/html
COPY ./composer.local.json composer.local.json
RUN apt-get update && apt-get install unzip zip
RUN git clone --depth 1 --branch $EXTENSION_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/PluggableAuth /var/www/html/extensions/PluggableAuth
RUN git clone --depth 1 --branch $EXTENSION_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/OpenIDConnect /var/www/html/extensions/OpenIDConnect
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php && rm composer-setup.php && php composer.phar install -n
