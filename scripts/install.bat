@echo off

if not exist .venv\ (
	python -m venv .venv
)

call .venv\Scripts\activate
python -m pip install pip setuptools wheel --upgrade
pip install -r requirements\local.txt --upgrade

if not exist .env (
	copy .\envs\local.env .env
)

if exist db.sqlite3 (
	del db.sqlite3
)

python app\manage.py collectstatic --noinput
python app\manage.py makemigrations
python app\manage.py migrate

python app\manage.py createsuperuser --username root --email root@email.com --noinput
python app\manage.py createsuperuser --username sudo --email sudo@email.com --noinput
python app\manage.py createsuperuser --username user --email user@email.com --noinput
