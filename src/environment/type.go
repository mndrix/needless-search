package environment

type Environment struct {
	// needed for IsInGitRepository()
	lookedForGitRepo  bool
	isInGitRepository bool
}

func New() *Environment {
	return &Environment{}
}
