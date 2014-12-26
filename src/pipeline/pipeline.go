package pipeline

import (
	"fmt"

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

func (p *Pipeline) AsBash() string {
	return fmt.Sprintf("%s | xargs -0 -n 1000 -P 8 %s", p.h.AsBash(), p.s.AsBash())
}
