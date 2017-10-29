FILES = $(shell ls test/test_*.sh)

test_runit:
	bash bin/roundup $(FILES)

release_files:
	mkdir dist
	cp -r prod/* dist/
	cp -r prod/.env dist/
	cp runit dist/

start_runit:
	cd dist ; ./runit

clean:
	rm -rf dist

test: test_runit
dist: clean test release_files
run: clean dist start_runit

.PHONY: test
