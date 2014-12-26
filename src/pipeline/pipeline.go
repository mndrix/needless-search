package pipeline

import (
	"haystack"
	"search"
)

type Pipeline struct {
	h *haystack.Haystack
	s *search.Search
}

func New(h *haystack.Haystack, s *search.Search) *Pipeline {
	return &Pipeline{
		h: h,
		s: s,
	}
}
