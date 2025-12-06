FROM php:8.5-apache

# install some base extensions
RUN apt-get update \
  && apt-get install -y libzip-dev zip libicu-dev libgmp-dev libpng-dev libjpeg-dev libmagickwand-dev libsodium-dev libpq-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-configure gd --with-jpeg=/usr/include \
  && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
  && docker-php-ext-install zip pdo pdo_mysql pdo_pgsql intl gmp gd sodium \
  && useradd --home /code --no-create-home --uid 1000 dev \
  && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer \
  && a2enmod rewrite

COPY rootfs /

WORKDIR "/code"
