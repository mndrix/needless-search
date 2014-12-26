package haystack

type Haystack struct {
	query string
}

// New creates a new Haystack value based on a user's request
func New(query string) *Haystack {
	return &Haystack{
		query: query,
	}
}
