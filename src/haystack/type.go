package haystack

import "environment"

type Haystack struct {
	env   *environment.Environment
	query string
}

// New creates a new Haystack value based on a user's request
func New(env *environment.Environment, query string) *Haystack {
	return &Haystack{
		env:   env,
		query: query,
	}
}
