#!/usr/bin/env bash

# Install Postgres
apt install postgresql -y
sudo -u postgres psql -c "CREATE USER \"www-data\" WITH ENCRYPTED PASSWORD 'pass';"
sudo -u postgres psql -c "CREATE DATABASE web;"
sudo -u postgres psql -c "ALTER DATABASE web OWNER TO \"www-data\";"

# Install app
apt install python3-venv -y
python3 -m venv /srv/web/venv
/srv/web/venv/bin/python3 -m pip install pip setuptools wheel --upgrade --no-cache-dir
/srv/web/venv/bin/python3 -m pip install -r /srv/web/requirements/prod.txt --upgrade --no-cache-dir
cp /srv/web/envs/prod.env /srv/web/.env
SECRET_KEY=$(python3 -c "import secrets;print(secrets.token_urlsafe(64))")
sed -i "s/<SECRET_KEY>/$SECRET_KEY/g" /srv/web/.env
/srv/web/venv/bin/python3 /srv/web/app/manage.py collectstatic
/srv/web/venv/bin/python3 /srv/web/app/manage.py migrate

# install Gunicorn
cp /srv/web/deploy/debian/gunicorn.service /etc/systemd/system/gunicorn.service
cp /srv/web/deploy/debian/gunicorn.socket /etc/systemd/system/gunicorn.socket
systemctl daemon-reload
systemctl start gunicorn.socket
systemctl enable gunicorn.socket

# install NGINX
apt install nginx -y
cp /srv/web/deploy/debian/app.conf /etc/nginx/conf.d/app.conf
systemctl daemon-reload
systemctl restart nginx
systemctl enable nginx
