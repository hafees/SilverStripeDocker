#Environment variables
ARG PHP_VERSION

FROM php:${PHP_VERSION}-apache-stretch

ENV APACHE_DOCUMENT_ROOT /var/www/app/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY ./php/root/ /root/

RUN apt-get update -y && apt-get install -y \
        nano \
        curl \
        git \
        gzip \
        unzip \
        zip \
        libpng-dev \
        libwebp-dev \
        libjpeg62-turbo-dev \
        libxpm-dev \
        libfreetype6-dev \
        zlib1g-dev \
        libicu-dev \
        g++ \
        gnupg2 \
        software-properties-common

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -y && apt-get install -y nodejs

RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
        --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
        --enable-gd-native-ttf 

RUN docker-php-ext-install gd \
        intl \
        pdo \
        pdo_mysql 

#Install Tidy
RUN apt-get install -y libtidy-dev \
        && docker-php-ext-install tidy \
        && docker-php-ext-enable tidy

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=/usr/local/bin

# Enable mod_rewrite and ssl
RUN a2enmod rewrite


