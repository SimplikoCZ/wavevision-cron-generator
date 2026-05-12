FROM php:8.5-cli-alpine

RUN apk add --no-cache \
    bash \
    git \
    icu-dev \
    libzip-dev \
    unzip \
    zip

RUN docker-php-ext-install intl zip

RUN apk add --no-cache $PHPIZE_DEPS linux-headers \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del $PHPIZE_DEPS linux-headers

RUN printf "xdebug.mode=coverage\n" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /app
