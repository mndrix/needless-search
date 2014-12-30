all: langs.go
	env GOPATH=`pwd` go build

langs.go: languages.yaml langs.pl
	perl langs.pl > langs.go
	gofmt -w langs.go

languages.yaml:
	curl -L --silent 'https://github.com/github/linguist/raw/master/lib/linguist/languages.yml' > languages.yaml
