all: src/lang/langs.go
	env GOPATH=`pwd` go build

src/lang/langs.go: languages.yaml langs.pl langs.tt
	mkdir -p src/lang
	perl langs.pl > src/lang/langs.go
	gofmt -w src/lang/langs.go

languages.yaml:
	curl -L --silent 'https://github.com/github/linguist/raw/master/lib/linguist/languages.yml' > languages.yaml
