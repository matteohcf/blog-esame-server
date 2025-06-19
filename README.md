## Esame Symfony - Blog di post

Questo progetto rappresenta un'applicazione di blog (con gestione utenti e post) full-stack composta da backend, frontend e database, tutti ospitati su **Render (servizio di hosting e deploy molto potente)**.

### Tecnologie utilizzate

* **Backend:** Symfony, con API esposte tramite **API Platform** e gestione del database con **Doctrine ORM**
* **Frontend:** Vue.js (disponibile a [https://blog-esame-backoffice.onrender.com](https://blog-esame-backoffice.onrender.com))
* **Database:** PostgreSQL, ospitato su Render e collegato internamente al backend
* **Hosting:** Tutte le parti del progetto sono ospitate su [Render](https://render.com)

### Backend

Il backend è disponibile all'api:
[https://blog-esame-server.onrender.com/api](https://blog-esame-server.onrender.com/api)

#### API disponibili

* `POST /register` – Registrazione utente
* `POST /login_check` – Login con JWT (gestito tramite `lexik/jwt-authentication-bundle`)
* `GET /users/me` – Restituisce i dati dell’utente autenticato
* `POST /articles` – Crea un nuovo post
* `PUT /articles/:id` – Modifica un post
* `GET /articles` – Restituisce tutti i post
* `GET /articles/:id` – Restituisce un singolo post

NB: è stato molto importante configurare il file [security.yaml](./config/packages/security.yaml) sia per gestire l'autenticazione JWT che per definire i permessi di accesso alle varie rotte.

#### [Dockerfile](./Dockerfile) per il backend

Il backend è stato containerizzato per Render con un semplice **Dockerfile** basato su PHP 8.2. Questo permette di installare le dipendenze necessarie, configurare l’ambiente e avviare il server Symfony.

```Dockerfile
FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_pgsql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY composer.json composer.lock ./

RUN composer install --no-dev --optimize-autoloader

COPY . .

RUN chown -R www-data:www-data /var/www

EXPOSE 8000

CMD composer install --no-dev --optimize-autoloader && php -S 0.0.0.0:8000 -t public
```

### Postman Collection
Per testare facilmente le API, se necessario, è possibile scaricare la collection Postman

[Apri la Collection](./esame.postman_collection.json)


### Funzionamento del deploy su Render

Render automatizza il deploy: ogni volta che si effettua un **push** su GitHub, Render esegue automaticamente una **pipeline** che costruisce e aggiorna il progetto. Questo permette un ciclo di sviluppo continuo e semplice.

---

NB: Il piano gratuito di render, se non utilizzato spesso, si spegne e ci mette circa 50 secondi ad accendersi, quindi se il sito e le api non sono subito funzionanti bisogna attendere e nel caso riprovare

NB: L'entità utlizzata e quella a cui fare riferimento non è Post ma Article
