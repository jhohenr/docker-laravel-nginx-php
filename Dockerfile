FROM ubuntu:18.04

MAINTAINER Jhonatan Henrique <jhohcs@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

# Download packages
RUN apt-get update && apt-get upgrade -y && apt-get install -yq --no-install-recommends \
    nginx \
    ca-certificates \
    curl \
    git \
    zip \
    unzip \
    php7.2 \
    php7.2-cli \
    php7.2-fpm \
    php7.2-ctype \
    php7.2-curl \
    php7.2-json \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-tokenizer \
    php7.2-xml \
    php7.2-zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Setup NGINX
COPY docker/nginx/default /etc/nginx/sites-enabled/default

# Copy application
COPY . /app

# Copy .env
COPY .env.prod /app/.env

# Set app folder as workdir
WORKDIR /app

# Give permissions to folder
RUN chmod -R 755 /app \
    && chown -R www-data /app

# Install project dependencies
RUN composer install --no-dev

# Expose 80 and 443 ports
EXPOSE 80 443

# Run
CMD ["service", "php7.2-fpm", "start"]
CMD ["nginx", "-g", "daemon off;"]
