package environment

import "os"

// IsInGitRepository() returns true if the active directory is
// inside a Git repository.  It doesn't have to be the repository's root,
// just within the repo.
func (e *Environment) IsInGitRepository() bool {
	// use cached value if we've already done the hard work
	if e.lookedForGitRepo {
		return e.isInGitRepository
	}
	e.lookedForGitRepo = true

	// heuristic: presence of .git directory is right 99.9% of the time
	fi, err := os.Stat(".git")
	e.isInGitRepository = err == nil && fi.IsDir()

	return e.isInGitRepository
}
