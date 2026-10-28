FROM php:8.4-fpm

# Validate the PHP version contains the required security fix
RUN php -r 'if (version_compare(PHP_VERSION, "8.4.27", "<")) { fwrite(STDERR, "ERROR: PHP >= 8.4.27 required for security fix, got " . PHP_VERSION . "\n"); exit(1); }'

# install some base extensions
RUN apt-get update \
  && apt-get install -y --only-upgrade ca-certificates \
  && update-ca-certificates \
  && apt-get install -y libzip-dev zip unzip libicu-dev libgmp-dev libpng-dev libjpeg-dev libmagickwand-dev libsodium-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-configure gd --with-jpeg=/usr/include \
  && docker-php-ext-install zip pdo pdo_mysql intl gmp gd opcache sodium \
  && curl -fsSL -o /tmp/pie.phar https://github.com/php/pie/releases/latest/download/pie.phar \
  && php /tmp/pie.phar install phpredis/phpredis pecl/timezonedb \
  && rm /tmp/pie.phar \
  && useradd --home /code --no-create-home --uid 1000 dev \
  && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

# composer/ca-bundle, vendored inside the Composer phar, still ships the compromised
# "emSign ECC Root CA - G3" root, and Composer falls back to it when it cannot read the
# system trust store. Replace it with the system store, then fail the build if either
# store still trusts a compromised eMudhra root.
# https://emudhra.we-have-a-problem.com/
RUN php -d phar.readonly=0 -r 'copy("/usr/bin/composer", "/tmp/composer.phar"); \
    $p = new Phar("/tmp/composer.phar"); \
    $p->startBuffering(); \
    $p["vendor/composer/ca-bundle/res/cacert.pem"] = file_get_contents("/etc/ssl/certs/ca-certificates.crt"); \
    $p->stopBuffering();' \
  && mv /tmp/composer.phar /usr/bin/composer \
  && chmod +x /usr/bin/composer \
  && php -r 'Phar::loadPhar("/usr/bin/composer", "composer.phar"); \
    $bad = ["d7a7a0fb5d7e2731d771e9484ebcdef71d5f0c3e0a2948782bc83ee0ea699ef4", "86a1ecba089c4a8d3bbe2734c612ba341d813e043cf9e8a862cd5c57a36bbe6b"]; \
    $fail = 0; \
    foreach (["/etc/ssl/certs/ca-certificates.crt", "phar://composer.phar/vendor/composer/ca-bundle/res/cacert.pem"] as $f) { \
      preg_match_all("/-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/s", file_get_contents($f), $m); \
      foreach ($m[0] as $c) { \
        if (in_array(hash("sha256", base64_decode(preg_replace("/-----[^-]+-----|\s/", "", $c))), $bad, true)) { \
          fwrite(STDERR, "ERROR: compromised eMudhra root still trusted in $f\n"); \
          $fail = 1; \
        } \
      } \
      printf("%4d certs  %s\n", count($m[0]), $f); \
    } \
    exit($fail);'

WORKDIR "/code"
