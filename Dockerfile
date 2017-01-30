FROM php:5.6-apache

MAINTAINER Richard Papp "contact@boromino.com"

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_DOC_ROOT /var/www/html

RUN a2enmod rewrite
COPY ./config/001-docker.conf /etc/apache2/sites-available/001-docker.conf
RUN a2dissite 000-default && a2ensite 001-docker

# Install PHP extensions
RUN apt-get update && \
    apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    apt-get install -y libmcrypt-dev && \
    docker-php-ext-install mcrypt && \
    docker-php-ext-install mysqli pdo_mysql && \
    docker-php-ext-install opcache && \
    pecl install redis-3.1.0 && \
    pecl install xdebug-2.5.0 && \
    docker-php-ext-enable redis xdebug && \
    apt-get install -y mysql-client && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Add custom configuration
COPY config/php.ini /usr/local/etc/php/
COPY ./config/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

