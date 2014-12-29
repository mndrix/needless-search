package environment

import (
	"fmt"
	"io"
)

// WriteHeader writes a header message to w and terminates it with a newline.
func (e *Environment) WriteHeader(w io.Writer, msg string) {
	if e.isNotFirstHeader {
		io.WriteString(w, "\n")
	}
	e.isNotFirstHeader = true

	color(w, 1, 32)
	io.WriteString(w, msg)
	reset(w)
	io.WriteString(w, "\n")
}

// WriteLineNumberColor outputs the color code for a line number
func (*Environment) WriteLineNumberColor(w io.Writer) {
	color(w, 1, 33)
}

// WriteResetColor outputs a color code to reset colors back to normal
func (*Environment) WriteResetColor(w io.Writer) {
	reset(w)
}

// WriteMatchColor outputs a color code to reset colors back to normal
func (*Environment) WriteMatchColor(w io.Writer) {
	color(w, 30, 43)
}

func color(w io.Writer, a, b int) {
	io.WriteString(w, fmt.Sprintf("\033[%d;%dm", a, b))
}

func reset(w io.Writer) {
	io.WriteString(w, "\033[0m")
}
