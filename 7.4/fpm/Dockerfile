FROM php:7.4-fpm-alpine AS app

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV USER www-data
ENV HOME /code
ENV COMPOSER_HOME=/code

RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache gnupg curl icu libpng libzip-dev \
    && apk add --no-cache --virtual build-dependencies icu-dev \
        libxml2-dev freetype-dev libpng-dev libjpeg-turbo-dev \
        g++ make autoconf gmp-dev \
    && docker-php-ext-install -j$(nproc) gmp pdo pdo_mysql intl zip gd \
    && cd  / && rm -fr /src \
    && apk del build-dependencies \
    && rm -rf /tmp/*

COPY rootfs /

WORKDIR "/code"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

# install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
