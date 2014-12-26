package haystack

import "fmt"

// AsBash renders the haystack as a bash command which outputs all files
// worth considering.
func (h *Haystack) AsBash() string {
	return fmt.Sprintf("mdfind -onlyin . -0 '%s'", h.query)
}
