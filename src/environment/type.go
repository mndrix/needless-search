package environment

import (
	"fmt"
	"os"

	"lang"
)

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

	// languages the user wants us to search
	Languages []*lang.Language

	// needed for IsInGitRepository()
	lookedForGitRepo  bool
	isInGitRepository bool

	// needed for Header()
	isNotFirstHeader bool
}

// New creates a new environment encapsulating all the user's preferences
// (both for this search and in general)
func New() (*Environment, error) {
	if len(os.Args) < 2 {
		Usage()
		return nil, nil
	}

	env := new(Environment)
	env.Languages = make([]*lang.Language, 0)

ArgLoop:
	for i, arg := range os.Args {
		if i == 0 {
			env.NdlPath = arg
			continue
		}

		switch arg {
		case "--reformat-grep-output":
			env.Mode = ReformatGrepOutput
			env.Query = os.Args[i+1]
			break ArgLoop
		default:
			if option, ok := isOption(arg); ok {
				lang := lang.ByNickname(option)
				if lang != nil {
					env.Languages = append(env.Languages, lang)
					continue
				}
				return nil, fmt.Errorf("Unknown option '%s'", arg)
			} else {
				env.Mode = Search
				env.Query = arg
				break ArgLoop
			}
		}
	}

	// final validation of the environment
	if env.Query == "" {
		return nil, fmt.Errorf("You must provide a search pattern")
	}

	return env, nil
}

func isOption(arg string) (string, bool) {
	if len(arg) < 2 {
		return "", false
	}

	if arg[0:2] == "--" {
		return arg[2:], true
	}

	return "", false
}
