package search

import "fmt"

// AsBash renders the user's search as a bash command.  This is typically
// an invocation of grep.
func (s *Search) AsBash() string {
	return fmt.Sprintf("grep -H -n --color '%s'", s.query)
}
