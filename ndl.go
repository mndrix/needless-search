package main

import (
	"fmt"
	"os"

	"environment"
	"haystack"
	"pipeline"
	"search"
)

func main() {
	// parse and verify user's request
	if len(os.Args) < 2 {
		usage()
		return
	}
	query := os.Args[1]

	// construct the user's environment
	env := environment.New()

	// convert user's needle into a search
	s := search.New(query)

	// convert user's request into a haystack
	h := haystack.New(env, query)

	// make a pipeline to generate output
	p := pipeline.New(h, s)
	err := p.Run()
	if err != nil {
		panic(err)
	}
}

func usage() {
	fmt.Fprintf(os.Stderr, usageString)
}

const usageString = `Usage: ndl pattern
`
