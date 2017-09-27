FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \
    apt-get update

RUN apt-get -q update \
    && apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends \
    php5.6 php5.6-cli php5.6-curl php-redis php5.6-mysql php5.6-sqlite php5.6-mcrypt php-pear \
    php5.6-fpm php5.6-json php5.6-xml php5.6-mbstring php5.6-zip php5.6-intl php5.6-bcmath php5.6-soap php5.6-gd \
    git curl ca-certificates postfix libsasl2-modules

RUN apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/*.bin

WORKDIR /code
EXPOSE 9000

# PHP
ADD etc/php/php-fpm.conf /etc/php/5.6/fpm/php-fpm.conf
ADD etc/php/www.conf /etc/php/5.6/fpm/pool.d/www.conf
ENV PHP_UID www-data
ENV PHP_GID www-data

# Postfix
ENV SMTP_ENABLE 0
ENV SMTP_MYHOSTNAME localhost
ENV SMTP_HOST null
ENV SMTP_USER null
ENV SMTP_PASSWORD null

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

