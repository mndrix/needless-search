package pipeline

import (
	"fmt"
	"strings"
)

func (p *Pipeline) AsBash() string {
	return fmt.Sprintf(
		"%s | %s %s",
		strings.Join(p.h.AsBash(), " "),
		strings.Join(Fanout(), " "),
		strings.Join(p.s.AsBash(), " "),
	)
}

func Fanout() []string {
	return []string{
		"xargs",
		"-0",
		"-n", "1000",
		"-P", "8",
	}
}
