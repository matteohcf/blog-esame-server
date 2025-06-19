FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_pgsql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# 🔥 COPIA TUTTO IL PROGETTO PRIMA!
COPY . .

# ✅ Composer install con tutto il codice già presente
RUN composer install --no-dev --optimize-autoloader

# Permessi
RUN chown -R www-data:www-data /var/www

# ENTRYPOINT con migrations
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["docker-entrypoint.sh"]
