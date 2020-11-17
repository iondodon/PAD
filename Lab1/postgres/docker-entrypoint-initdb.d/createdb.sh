#!/bin/sh

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER default_user WITH PASSWORD 'secret';
    CREATE DATABASE orders_db;
    GRANT ALL PRIVILEGES ON DATABASE orders_db TO default_user;
EOSQL