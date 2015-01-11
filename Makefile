all: swipl

go:
	env GOPATH=`pwd` go build

src/langs.pl: languages.yaml langs.pl langs.tt
	perl langs.pl > src/langs.pl

languages.yaml:
	curl -L --silent 'https://github.com/github/linguist/raw/master/lib/linguist/languages.yml' > languages.yaml

swipl: ndl.pl src/langs.pl
	swipl -q -t main -o ndl -c ndl.pl
