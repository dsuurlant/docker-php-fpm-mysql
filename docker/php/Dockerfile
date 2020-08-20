# see https://medium.com/@othillo/adding-composer-to-php-docker-images-using-multi-stage-builds-2a10967ae6c1

# start with the official Composer image and name it
FROM composer:1.9.1 AS composer

# continue with the official PHP image
FROM php:7.4.9-fpm-buster

# copy the Composer PHAR from the Composer image into the PHP image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends libxslt-dev git zip unzip libonig-dev openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install PHP Core extensions
RUN docker-php-ext-install pdo_mysql bcmath xsl sockets intl

# install APCu extension
RUN pecl install apcu && docker-php-ext-enable apcu

# enable this to install Xdebug
#"zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so"
#RUN pecl install xdebug \
#    && docker-php-ext-enable xdebug \
#    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#    && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#    && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#    && echo "xdebug.show_local_vars=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#
#ENV PHP_IDE_CONFIG "serverName=localhost"

# show that both Composer and PHP run as expected
RUN composer --version && php -v && php -m

# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER=1

# Set composer memory limit
ENV COMPOSER_MEMORY_LIMIT=1024M

# Trust GitHub servers
RUN ssh-keyscan github.com >> /etc/ssh/ssh_known_hosts

WORKDIR /app

COPY --chown=www-data:www-data . /app