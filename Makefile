# Prereqs:
#    install node, ruby, wget, then:
#
#    npm install pegjs
#    gem install ruby2js
#    https://github.com/tabatkins/bikeshed/blob/master/docs/install.md
#
#    To run the reference-implementation cgi scripts:
#
#    gem install wunderbar

all: spec test

clean:
	rm -f url.html url.bs url.pegjson reference-implementation/url.js \
	reference-implementation/urlparser.js test/urltest.js

#
### specification
#
spec: url.html

url.html: url.bs
	bikeshed spec

url.bs: json2bikeshed.rb url.pegjson url.pegjs
	ruby json2bikeshed.rb > $@

url.pegjson: peg2json.js parser.pegjs url.pegjs
	node peg2json.js > $@

#
### test reference implementation
#
test: reference-implementation/punycode.js reference-implementation/url.js \
	reference-implementation/urlparser.js test/urltest.js test/urltestparser.js test/urltestdata.txt
	node test/urltest.js

test/urltest.js: reference-implementation/ruby2js test/urltest.rb
	ruby reference-implementation/ruby2js test/urltest.rb > $@

reference-implementation/url.js: reference-implementation/ruby2js reference-implementation/url.rb
	ruby reference-implementation/ruby2js reference-implementation/url.rb > $@

reference-implementation/urlparser.js: reference-implementation/pegcompile.js url.pegjs
	node reference-implementation/pegcompile.js > $@

#
### Fetch files from other sources
#
clobber:
	rm -f test/urltestdata.txt test/urltestparser.js parser.pegjs \
	reference-implementation/punycode.js

fetch: clobber test/urltestdata.txt test/urltestparser.js parser.pegjs \
	reference-implementation/punycode.js

test/urltestdata.txt:
	cd test; \
	wget https://raw.githubusercontent.com/w3c/web-platform-tests/master/url/urltestdata.txt

test/urltestparser.js:
	cd test; \
	wget https://raw.githubusercontent.com/w3c/web-platform-tests/master/url/urltestparser.js

parser.pegjs:
	wget https://raw.githubusercontent.com/dmajda/pegjs/master/src/parser.pegjs

reference-implementation/punycode.js:
	cd reference-implementation; \
	wget https://raw.githubusercontent.com/bestiejs/punycode.js/master/punycode.js
