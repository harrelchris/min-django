@echo off

call .venv\Scripts\activate
python app\manage.py runserver localhost:80
