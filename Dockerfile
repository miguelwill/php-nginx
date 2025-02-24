FROM ubuntu:24.04

ENV TERM=xterm \
    SHELL=bash \
    DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    PHP_VERSION=8.3 \
    NODE_VERSION=20.x

#install php
RUN apt-get update && \
    apt-get dist-upgrade -y

RUN apt-get install -y \
    bash supervisor nginx git curl sudo zip unzip xz-utils libxrender1 gnupg \
    php$PHP_VERSION php$PHP_VERSION-apcu php$PHP_VERSION-bz2 php$PHP_VERSION-cli php$PHP_VERSION-curl php$PHP_VERSION-fpm php$PHP_VERSION-gd \
    php-php-gettext php$PHP_VERSION-gmp php-imagick php$PHP_VERSION-imap php$PHP_VERSION-mbstring php$PHP_VERSION-zip \
    php$PHP_VERSION-memcached php$PHP_VERSION-mongodb php$PHP_VERSION-mysql php-pear php$PHP_VERSION-redis php$PHP_VERSION-xml php$PHP_VERSION-intl php$PHP_VERSION-soap \
    php$PHP_VERSION-sqlite3 php-fpdf php$PHP_VERSION-bcmath php$PHP_VERSION-opcache php$PHP_VERSION-pgsql ssmtp

#install node
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | sudo -E bash && \
    apt-get install -y nodejs && \
    curl -o- -L https://yarnpkg.com/install.sh | bash -s -- && \
    ln -sfv /root/.yarn/bin/yarn /bin && \
    rm -rf /var/cache/apt && rm -rf /var/lib/apt && \
    curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin --filename=composer && \
    mkdir -p /run/php && \
    mkdir -p /var/www && \
    chown -R www-data:www-data /var/www /root

ENV HOME=/var/www
EXPOSE 80
ENTRYPOINT ["entrypoint"]

RUN ln -vs /var/www/ /home/www-data && \
    ln -fs /conf/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    ln -fs /conf/php.ini /etc/php/${PHP_VERSION}/fpm/php.ini && \
    ln -fs /conf/nginx.conf /etc/nginx/nginx.conf && \
    ln -fs /conf/nginx-default /etc/nginx/conf.d/default.conf && \
    ln -fs /conf/supervisord.conf /etc/supervisord.conf

COPY bin /bin
COPY conf /conf
