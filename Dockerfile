FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    zip \
    unzip \
    bzip2 \
    libxml2-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo_mysql zip opcache intl

RUN a2enmod rewrite headers env dir mime

RUN curl -fsSL -o nextcloud.tar.bz2 https://download.nextcloud.com/server/releases/nextcloud-29.0.3.tar.bz2 \
    && tar -xjf nextcloud.tar.bz2 -C /var/www/html/ \
    && rm nextcloud.tar.bz2 \
    && chown -R www-data:www-data /var/www/html/nextcloud

RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/nextcloud/' /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]