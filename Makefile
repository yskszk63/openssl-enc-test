.PHONY: check-all
check-all: check-openssl check-ruby check-php check-python check-node check-go check-java

.PHONY: build-docker
build-docker: build-docker-python build-docker-go

out/openssl.txt:
	mkdir -p out
	echo -n 'Hello, World!' | openssl aes-256-cbc -e -pbkdf2 -iter 1000 -k SECRET | base64 | tee $@

.PHONY: check-openssl
check-openssl: out/openssl.txt
	diff <(base64 -d $< | openssl aes-256-cbc -d -pbkdf2 -iter 1000 -k SECRET) <(echo -n "Hello, World!")

out/ruby.txt: ruby.rb
	mkdir -p out
	docker run --rm -v$(CURDIR):/app ruby:3.1.3-slim-bullseye ruby /app/$< | tee $@

.PHONY: check-ruby
check-ruby: out/ruby.txt
	diff <(base64 -d $< | openssl aes-256-cbc -d -pbkdf2 -iter 1000 -k SECRET) <(echo -n "Hello, World!")

out/php.txt: php.php
	mkdir -p out
	docker run --rm -v$(CURDIR):/app php:8-cli-bullseye php /app/$< | tee $@

.PHONY: check-php
check-php: out/php.txt
	diff <(base64 -d $< | openssl aes-256-cbc -d -pbkdf2 -iter 1000 -k SECRET) <(echo -n "Hello, World!")

.PHONY: build-docker-python
build-docker-python:
	docker buildx build -t openssl-enc-test-python ./docker/python

out/python.txt: python.py
	mkdir -p out
	docker run --rm -v$(CURDIR):/app openssl-enc-test-python python /app/$< | tee $@

.PHONY: check-python
check-python: out/python.txt
	diff <(base64 -d $< | openssl aes-256-cbc -d -pbkdf2 -iter 1000 -k SECRET) <(echo -n "Hello, World!")

out/node.txt: node.mjs
	mkdir -p out
	docker run --rm -v$(CURDIR):/app node:19.2.0-bullseye-slim node /app/$< | tee $@

.PHONY: check-node
check-node: out/node.txt
	diff <(base64 -d $< | openssl aes-256-cbc -d -pbkdf2 -iter 1000 -k SECRET) <(echo -n "Hello, World!")

.PHONY: build-docker-go
build-docker-go:
	docker buildx build -t openssl-enc-test-go ./docker/go

out/go.txt: go.go
	mkdir -p out
	docker run --rm -v$(CURDIR):/app openssl-enc-test-go go run /app/$< | tee $@

.PHONY: check-go
check-go: out/go.txt
	diff <(base64 -d $< | openssl aes-256-cbc -d -pbkdf2 -iter 1000 -k SECRET) <(echo -n "Hello, World!")

out/java.txt: Java.java
	mkdir -p out
	docker run --rm -v$(CURDIR):/app eclipse-temurin:19.0.1_10-jdk-jammy java /app/$< | tee $@

.PHONY: check-java
check-java: out/java.txt
	diff <(base64 -d $< | openssl aes-256-cbc -d -pbkdf2 -iter 1000 -k SECRET) <(echo -n "Hello, World!")

.PHONY: clean
clean:
	$(RM) -r out
