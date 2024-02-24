#!/usr/bin/env bash

if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate
python3 -m pip install pip setuptools wheel --upgrade
pip install -r requirements/local.txt --upgrade

if [ ! -f ".env" ]; then
    cp ./envs/local.env .env
fi

if [ -f "db.sqlite3" ]; then
    rm db.sqlite3
fi

python3 app/manage.py collectstatic --noinput
python3 app/manage.py makemigrations
python3 app/manage.py migrate

python3 app/manage.py createsuperuser --username root --email root@email.com --noinput
python3 app/manage.py createsuperuser --username sudo --email sudo@email.com --noinput
python3 app/manage.py createsuperuser --username user --email user@email.com --noinput
