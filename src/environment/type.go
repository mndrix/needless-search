package environment

import "os"

type Environment struct {
	// user's original search query
	Query string

	// needed for IsInGitRepository()
	lookedForGitRepo  bool
	isInGitRepository bool

	// needed for Header()
	isNotFirstHeader bool
}

// New creates a new environment encapsulating all the user's preferences
// (both for this search and in general)
func New() *Environment {
	if len(os.Args) < 2 {
		Usage()
		return nil
	}
	query := os.Args[1]

	return &Environment{
		Query: query,
	}
}
