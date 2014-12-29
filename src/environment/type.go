package environment

type Environment struct {
	// needed for IsInGitRepository()
	lookedForGitRepo  bool
	isInGitRepository bool

	// needed for Header()
	isNotFirstHeader bool
}

func New() *Environment {
	return &Environment{}
}
