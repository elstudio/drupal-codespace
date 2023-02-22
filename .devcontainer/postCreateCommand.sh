#!/bin/bash

sudo a2enmod rewrite

# Install php gd library
sudo apt update
sudo apt install -y --no-install-recommends \
  libfreetype6-dev \
  libjpeg-dev \
  zlib1g-dev \
  libpng-dev \
  libpq-dev \
  libzip-dev \
  libwebp-dev \
  default-mysql-client \
  gettext-base \
  libpcre2-32-0 \
  build-essential


# set -eux
sudo docker-php-ext-configure gd \
  --with-freetype \
  --with-jpeg=/usr \
  --with-webp
sudo docker-php-ext-install -j "$(nproc)" \
  gd \
  opcache \
  pdo_mysql \
  pdo_pgsql \
  zip
  
sudo ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
  | awk '/=>/ { print $3 }' \
  | sort -u \
  | xargs -r dpkg-query -S \
  | cut -d: -f1 \
  | sort -u \
  | xargs -rt apt-mark manual