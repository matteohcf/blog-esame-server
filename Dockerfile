FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data /var/www

EXPOSE 8000

# Opzione 1: solo server PHP (base)
# CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]

# Opzione 2: server PHP + migrate (consigliato se usi Doctrine)
CMD php bin/console doctrine:migrations:migrate --no-interaction && php -S 0.0.0.0:8000 -t public
