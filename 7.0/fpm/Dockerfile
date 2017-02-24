FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update \
    && apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends \
    php7.0 php7.0-cli php7.0-curl php-redis php7.0-mysql php7.0-sqlite php7.0-mcrypt php-pear \
    php7.0-fpm php7.0-json php7.0-xml php7.0-mbstring php7.0-zip php-intl php-gd php7.0-bcmath \
    git nodejs curl ca-certificates

RUN apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/*.bin

RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Toronto/g' /etc/php/7.0/cli/php.ini && \
	sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Toronto/g' /etc/php/7.0/fpm/php.ini

ADD php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
ADD www.conf /etc/php/7.0/fpm/pool.d/www.conf
ENV PHP_UID www-data
ENV PHP_GID www-data

EXPOSE 9000
VOLUME /code
WORKDIR /code
ENTRYPOINT ["php-fpm7.0"]

