package environment

import "os"

type OperatingMode int

const (
	Search OperatingMode = iota
	ReformatGrepOutput
)

type Environment struct {
	// user's original search query
	Query string

	// path to the 'ndl' command
	NdlPath string

	// in which mode are we operating
	Mode OperatingMode

	// needed for IsInGitRepository()
	lookedForGitRepo  bool
	isInGitRepository bool

	// needed for Header()
	isNotFirstHeader bool
}

// New creates a new environment encapsulating all the user's preferences
// (both for this search and in general)
func New() *Environment {
	if len(os.Args) < 2 {
		Usage()
		return nil
	}

	env := new(Environment)

	for i, arg := range os.Args {
		if i == 0 {
			env.NdlPath = arg
			continue
		}

		switch arg {
		case "--reformat-grep-output":
			env.Mode = ReformatGrepOutput
			env.Query = os.Args[i+1]
			return env
		default:
			env.Mode = Search
			env.Query = arg
			return env
		}
	}

	return env
}
