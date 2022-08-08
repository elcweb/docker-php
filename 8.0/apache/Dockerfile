FROM php:8.1.9-apache

# install some base extensions
RUN pecl install redis && docker-php-ext-enable redis
RUN apt-get update \
  && apt-get install -y libzip-dev zip libicu-dev libgmp-dev libpng-dev libjpeg-dev libmagickwand-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-configure gd --with-jpeg=/usr/include \
  && docker-php-ext-install zip pdo pdo_mysql intl gmp gd opcache \
  && useradd --home /code --no-create-home --uid 1000 dev \
  && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer \
  && a2enmod rewrite

COPY rootfs /

WORKDIR "/code"
