FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \
    apt-get update

RUN apt-get -q update \
    && apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends \
    php5.6 php5.6-cli php5.6-curl php-redis php5.6-mysql php5.6-sqlite php5.6-mcrypt php-pear \
    php5.6-fpm php5.6-json php5.6-xml php5.6-mbstring php5.6-zip php5.6-intl php5.6-bcmath php-xdebug \
    git curl ssh supervisor nginx ca-certificates

RUN apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/*.bin

# Nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default

WORKDIR /code
EXPOSE 80
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]

ARG CACHE_DATE=2016-12-01_0000

COPY ./etc/site.conf /etc/nginx/sites-enabled/app.conf

# PHP
ADD etc/php/php-fpm.conf /etc/php/5.6/fpm/php-fpm.conf
ADD etc/php/www.conf /etc/php/5.6/fpm/pool.d/www.conf
ENV PHP_UID www-data
ENV PHP_GID www-data

# Supervisor config
ADD ./etc/supervisord.conf /etc/supervisord.conf

