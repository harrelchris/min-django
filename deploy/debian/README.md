# Deploy to Debian

```shell
sudo apt update
sudo apt upgrade -y
sudo apt install git -y
sudo git clone https://github.com/harrelchris/min-django.git /srv/web
sudo bash /srv/web/deploy/debian/install.sh
sudo /srv/web/venv/bin/python3 /srv/web/app/manage.py createsuperuser
```

## Update

```shell
(cd /srv/web && sudo git pull)
```

## Status

```shell
systemctl status nginx
systemctl status gunicorn.socket
systemctl status gunicorn.service
```

## Logs

```shell
# NGINX
journalctl -u nginx.service
tail /var/log/nginx/access.log
tail /var/log/nginx/error.log

# Gunicorn
journalctl -u gunicorn.socket

# Application
journalctl -u gunicorn.service

# Postgres
/var/log/postgresql/postgresql-13-main.log

# Timers
systemctl list-timers
systemctl --type=timer --all --failed

systemctl status example.timer
journalctl -u example.timer
```

## Restart

```shell
sudo bash /srv/web/deploy/debian/restart.sh
```

## Install Timer

```shell
sudo cp /srv/web/deploy/timers/example.service /etc/systemd/system/example.service
sudo cp /srv/web/deploy/timers/example.timer /etc/systemd/system/example.timer
sudo systemctl enable example.timer --now
```