ARG VERSION=1.46

FROM mediawiki:${VERSION}

ARG EXTENSION_BRANCH="REL1_46"

WORKDIR /var/www/html
COPY ./composer.local.json composer.local.json
COPY ./add-security-exceptions.sh /add-security-exceptions.sh
RUN apt-get update && apt-get install -y unzip zip jq
RUN git clone --depth 1 --branch $EXTENSION_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/PluggableAuth /var/www/html/extensions/PluggableAuth
RUN git clone --depth 1 --branch $EXTENSION_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/OpenIDConnect /var/www/html/extensions/OpenIDConnect
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN sh /add-security-exceptions.sh && rm /add-security-exceptions.sh
RUN php composer-setup.php && rm composer-setup.php && php composer.phar update --no-dev && php composer.phar install -n --no-dev
