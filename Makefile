bin=vendor/bin
codeSnifferRuleset=codesniffer-ruleset.xml
src=src
temp=temp
tests=tests
coverage=$(temp)/coverage/php
dirs:=$(src) $(tests)
docker_image=wavevision-cron-generator
docker_run=docker run --rm -v $(PWD):/app $(docker_image)

.PHONY: build docker-image reset phpcbf phpcs phpstan qa test test-coverage

build:
	composer install

docker-image:
	docker build -t $(docker_image) .

reset:
	rm -rf $(temp)/cache

phpcbf: docker-image
	$(docker_run) $(bin)/phpcbf -spn --standard=$(codeSnifferRuleset) --extensions=php $(dirs) ; true

phpcs: docker-image
	$(docker_run) $(bin)/phpcs -sp --standard=$(codeSnifferRuleset) --extensions=php $(dirs)

phpstan: docker-image
	$(docker_run) $(bin)/phpstan analyze $(dirs)

qa: phpcbf phpcs phpstan test

test: docker-image
	$(docker_run) sh -c "rm -rf $(temp)/cache && $(bin)/phpunit"

test-coverage: docker-image
	$(docker_run) sh -c "rm -rf $(temp)/cache && $(bin)/phpunit --coverage-html=$(coverage)"
