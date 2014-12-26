package haystack

import "fmt"

type Haystack struct {
	query string
}

// New creates a new Haystack value based on a user's request
func New(query string) *Haystack {
	return &Haystack{
		query: query,
	}
}

// AsBash renders the haystack as a bash command which outputs all files
// worth considering.
func (h *Haystack) AsBash() string {
	return fmt.Sprintf("mdfind -onlyin . -0 '%s'", h.query)
}
