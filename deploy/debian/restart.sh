#!/usr/bin/env bash

systemctl daemon-reload
systemctl stop gunicorn.socket
systemctl stop gunicorn.service
systemctl start gunicorn.socket
systemctl start gunicorn.service
systemctl restart nginx
