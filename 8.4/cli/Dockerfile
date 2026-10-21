FROM php:8.4-cli

# Validate the PHP version contains the required security fix
RUN php -r 'if (version_compare(PHP_VERSION, "8.4.27", "<")) { fwrite(STDERR, "ERROR: PHP >= 8.4.27 required for security fix, got " . PHP_VERSION . "\n"); exit(1); }'

# install some base extensions
RUN apt-get update \
  && apt-get install -y libzip-dev zip unzip libicu-dev libgmp-dev libpng-dev libjpeg-dev libmagickwand-dev libsodium-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-configure gd --with-jpeg=/usr/include \
  && docker-php-ext-install zip pdo pdo_mysql intl gmp gd opcache sodium \
  && curl -fsSL -o /tmp/pie.phar https://github.com/php/pie/releases/latest/download/pie.phar \
  && php /tmp/pie.phar install phpredis/phpredis pecl/timezonedb \
  && rm /tmp/pie.phar \
  && useradd --home /code --no-create-home --uid 1000 dev \
  && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

WORKDIR "/code"
