package haystack

// AsBash renders the haystack as a bash command which outputs all files
// worth considering.
func (h *Haystack) AsBash() []string {
	// Optimization:
	// If directory being search is "small", then using `find` is faster
	// than calling `mdutil`.  A find command which excludes .git
	// directories is:
	//
	//     find . -type d -name .git -prune -o -type f -print0

	return []string{
		"mdfind",
		"-onlyin", ".",
		"-0",
		h.query,
	}
}
