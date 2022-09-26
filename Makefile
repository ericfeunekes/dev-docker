.PHONY: build

build:.build/base-python

dir:
	mkdir -p build

.build/base-python: dir
	docker build . -f base-python.dockerfile -t base-python:latest
	touch .build/base-python
