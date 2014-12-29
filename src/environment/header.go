package environment

import (
	"fmt"
	"io"
)

// Header writes a header message to w and terminates it with a newline.
func (e *Environment) Header(w io.Writer, msg string) {
	if e.isNotFirstHeader {
		io.WriteString(w, "\n")
	}
	e.isNotFirstHeader = true

	color(w, 1, 33)
	io.WriteString(w, msg)
	reset(w)
	io.WriteString(w, "\n")
}

func color(w io.Writer, a, b int) {
	io.WriteString(w, fmt.Sprintf("\033[%d;%dm", a, b))
}

func reset(w io.Writer) {
	io.WriteString(w, "\033[0m")
}
