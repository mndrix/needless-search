package pipeline

import (
	"fmt"
	"runtime"
	"strconv"
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
	cpuCount := runtime.NumCPU()

	return []string{
		"xargs",
		"-0",
		"-n", "1000",
		"-P", strconv.Itoa(cpuCount),
	}
}
