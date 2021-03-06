install: .env
	@poetry install

.env:
	@test ! -f .env && cp .env.example .env

migrate:
	@poetry run python manage.py migrate

setup: migrate
	@echo Create a super user
	@poetry run python manage.py createsuperuser

shell:
	@poetry run python manage.py shell

# Need to have GNU gettext installed
transprepare:
	@poetry run django-admin makemessages --add-location file
	@poetry run django-admin makemessages --add-location file --domain djangojs

transcompile:
	@poetry run django-admin compilemessages

collectstatic:
	@poetry run python manage.py collectstatic --no-input

lint:
	@poetry run flake8

test:
	@poetry run python manage.py test

check: lint test requirements.txt

start: migrate transcompile
	@poetry run python manage.py runserver 0.0.0.0:8000

sync:
	@poetry run python manage.py fetchdata $(ARGS)

secretkey:
	@poetry run python -c 'from django.utils.crypto import get_random_string; print(get_random_string(40))'

requirements.txt: poetry.lock
	@poetry export --format requirements.txt --output requirements.txt

.PHONY: install setup shell lint test check start sync secretkey
