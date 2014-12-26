package search

type Search struct {
	query string
}

// New creates a new Search value based on a user's raw search query.
func New(query string) *Search {
	return &Search{
		query: query,
	}
}
