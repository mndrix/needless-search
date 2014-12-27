package search

// Needle returns the user's search query in a format suitable for grep.
// The second return value is true if the needle is a fixed string.
// In many cases, grep can perform a faster search in that case.
func (s *Search) Needle() (string, bool) {
	return s.query, true
}
