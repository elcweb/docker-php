FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update \
    && apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends \
    php7.0 php7.0-cli php7.0-curl php-redis php7.0-mysql php7.0-sqlite php7.0-mcrypt php-pear \
    php7.0-fpm php7.0-json php7.0-xml php7.0-mbstring php7.0-zip php7.0-intl php7.0-bcmath php-xdebug \
    git curl ssh supervisor nginx ca-certificates

RUN apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/*.bin

# Nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default

RUN mkdir /code
RUN chown -R www-data.www-data /code

WORKDIR /code
EXPOSE 80
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]

ARG CACHE_DATE=2016-12-01_0000

COPY ./etc/site.conf /etc/nginx/sites-enabled/app.conf

# PHP
ADD etc/php/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
ADD etc/php/www.conf /etc/php/7.0/fpm/pool.d/www.conf
ENV PHP_UID www-data
ENV PHP_GID www-data

# Supervisor config
ADD ./etc/supervisord.conf /etc/supervisord.conf
