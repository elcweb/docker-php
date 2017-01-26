FROM elcweb/php:7.0-fpm

ARG CACHE_DATE=2017-01-04_1526

RUN apt-get -q update \
    && apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends \
    php-xdebug

RUN apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/*.bin

ENV XDEBUG_HOST 172.17.0.1
ENV XDEBUG_PORT 9000
ENV XDEBUG_REMOTE_MODE req

ADD ./etc/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini

