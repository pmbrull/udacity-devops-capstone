lint:
	# See local hadolint install instructions: https://github.com/hadolint/hadolint
	# This is a linter for Dockerfiles
	# If we want to run it from a container
	# docker run --rm -i hadolint/hadolint < Dockerfile
	hadolint Dockerfile
	# This is a linter for Python source code linter: https://www.pylint.org/
	# This should be run from inside a virtualenv
	pylint --disable=R,C,W1203 app.py

build:
	docker build --build-arg APP_PORT=5000 --tag=pmbrull/k8-flask-api .

upload:
	sh ./scripts/upload_docker.sh