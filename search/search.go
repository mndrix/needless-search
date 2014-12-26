package search

import "fmt"

type Search struct {
	query string
}

// New creates a new Search value based on a user's raw search query.
func New(query string) *Search {
	return &Search{
		query: query,
	}
}

// AsBash renders the user's search as a bash command.  This is typically
// an invocation of grep.
func (s *Search) AsBash() string {
	return fmt.Sprintf("grep -H -n --color '%s'", s.query)
}
