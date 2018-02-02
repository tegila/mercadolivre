PATH := ./node_modules/.bin:${PATH}

.PHONY : init clean-docs clean build test dist publish

all: build

	
init:
	npm install

docs:
	docco src/*.coffee

clean-docs:
	rm -rf docs/

clean: clean-docs
	rm -rf lib/ test/*.js

build:
	#cat src/index.coffee > lib/mercadolivre.coffee
	#(GLOBIGNORE="index.coffee" ; cat  src/*.coffee  >> lib/mercadolivre.coffee)
	#coffee --compile lib/mercadolivre.coffee > lib/mercadolivre.js
	#coffee --output lib --compile src
	coffee --join lib/index.js --compile src/*.coffee
test:
	nodeunit test/refix.js

dist: clean init docs build test

publish: dist
	npm publish