package main

import (
	"fmt"
	"os"
	"time"

	"environment"
	"haystack"
	"pipeline"
	"search"
)

func main() {
	start := time.Now()

	// construct the user's environment (includes parsing command line)
	env := environment.New()
	if env == nil {
		return
	}
	query := env.Query

	// maybe punt to grep formatting mode
	if query == "--reformat-grep-output" {
		mainReformatGrepOutput(env)
		return
	}

	// convert user's needle into a search
	s := search.New(query)

	// convert user's request into a haystack
	h := haystack.New(env, query)

	// make a pipeline to generate output
	p := pipeline.New(env, h, s)
	err := p.Run()
	if err != nil {
		panic(err)
	}

	msg := fmt.Sprintf("Runtime: %s", time.Now().Sub(start))
	env.WriteHeader(os.Stderr, msg)
}
