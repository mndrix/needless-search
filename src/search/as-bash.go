package search

// AsBash renders the user's search as a bash command.  This is typically
// an invocation of grep.
func (s *Search) AsBash() []string {
	return []string{
		"grep",
		"-H",
		"-n",
		"--binary-files=without-match",
		s.query,
	}
}
