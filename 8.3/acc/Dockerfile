FROM php:8.3-apache

# install some base extensions
RUN apt-get update \
  && apt-get install -y libzip-dev zip libicu-dev libgmp-dev libpng-dev libjpeg-dev libmagickwand-dev libsodium-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-configure gd --with-jpeg=/usr/include \
  && docker-php-ext-install zip pdo pdo_mysql intl gmp gd opcache sodium \
  && pecl install redis \
  && docker-php-ext-enable redis \
  && useradd --home /code --no-create-home --uid 1000 dev \
  && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer \
  && a2enmod rewrite

ENV COMPOSER_ALLOW_SUPERUSER=1
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apt-get update \
    && apt-get install -y wget cron pdftk unixodbc-dev \
    && chmod uga+x /usr/local/bin/install-php-extensions \
    && sync \
    && install-php-extensions odbc pcntl pdo_odbc memcached memcache pdo_mysql mcrypt yaml zip soap mailparse opcache xsl sockets mysqli msgpack igbinary gettext exif calendar bz2 sqlsrv pdo_sqlsrv \
    && apt-get clean all

COPY rootfs /

RUN rm /etc/ssl/openssl.cnf && rm -rf /usr/local/etc/php/*
RUN usermod -u 48 www-data

WORKDIR "/code"
