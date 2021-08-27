FROM php:7.4-apache

#install some base extensions
RUN pecl install redis && docker-php-ext-enable redis
RUN apt-get update \
  && apt-get install -y libzip-dev zip libicu-dev libgmp-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-install zip pdo pdo_mysql intl gmp

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

COPY rootfs /

WORKDIR "/code"

