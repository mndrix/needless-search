package pipeline

import (
	"environment"
	"haystack"
	"search"
)

type Pipeline struct {
	env *environment.Environment
	h   *haystack.Haystack
	s   *search.Search
}

func New(env *environment.Environment, h *haystack.Haystack, s *search.Search) *Pipeline {
	return &Pipeline{
		env: env,
		h:   h,
		s:   s,
	}
}
