#!/bin/sh
set -e

# Esegui le migrations Doctrine
php bin/console doctrine:migrations:migrate --no-interaction

# Avvia il server PHP integrato
exec php -S 0.0.0.0:8000 -t public
