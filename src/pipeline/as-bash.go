package pipeline

import "fmt"

func (p *Pipeline) AsBash() string {
	return fmt.Sprintf("%s | xargs -0 -n 1000 -P 8 %s", p.h.AsBash(), p.s.AsBash())
}
