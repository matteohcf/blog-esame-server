# Stage 1: Composer (build stage)
FROM composer:2 AS composer

# Stage 2: PHP + Symfony
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_pgsql zip

# Copy Composer from stage 1
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy app source
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www

# Expose port for PHP built-in server
EXPOSE 8000

# Optional: run DB migrations then start PHP server
CMD php bin/console doctrine:migrations:migrate --no-interaction && php -S 0.0.0.0:8000 -t public
