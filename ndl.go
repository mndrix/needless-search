package main

import (
	"fmt"
	"os"

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

	// convert user's needle into a search
	s := search.New(query)

	// convert user's request into a haystack
	h := haystack.New(query)

	// make a pipeline to generate output
	p := pipeline.New(h, s)
	fmt.Println(p.AsBash())
}

func usage() {
	fmt.Fprintf(os.Stderr, usageString)
}

const usageString = `Usage: ndl pattern
`
