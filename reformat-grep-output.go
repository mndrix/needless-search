package main

import (
	"bufio"
	"bytes"
	"io"
	"os"
	"regexp"

	"environment"
)

// mainReformatGrepOutput implements an auxiliary ndl mode which formats
func mainReformatGrepOutput(env *environment.Environment) {
	prevPath := make([]byte, 0)
	w := os.Stdout
	pwdString, _ := os.Getwd()
	pwd := []byte(pwdString)
	rx := regexp.MustCompile(os.Args[2])

	r := bufio.NewReader(os.Stdin)
	for {
		// process file path
		path, err := r.ReadSlice(':')
		if err == io.EOF {
			break
		}
		path = path[0 : len(path)-1] // remove delimiter

		// we've just seen a new file
		if bytes.Compare(path, prevPath) != 0 {
			prevPath = append(prevPath[0:0], path...)

			// remove current directory from name
			if bytes.HasPrefix(path, pwd) {
				path = path[len(pwd)+1 : len(path)]
			}

			env.WriteHeader(w, string(path))
		}

		// process line number
		num, err := r.ReadSlice(':')
		if err == io.EOF {
			break
		}
		num = num[0 : len(num)-1] // remove delimiter
		env.WriteLineNumberColor(w)
		w.Write(num)
		env.WriteResetColor(w)
		w.WriteString(":")

		// process line content
		line, err := r.ReadSlice('\n')
		if err == io.EOF {
			break
		}

		// highlight matches
		upTo := 0
		matches := rx.FindAllIndex(line, -1)
		for _, match := range matches {
			start, end := match[0], match[1]
			if start > upTo {
				w.Write(line[upTo:start])
			}

			env.WriteMatchColor(w)
			w.Write(line[start:end])
			env.WriteResetColor(w)

			upTo = end
		}
		w.Write(line[upTo:len(line)])
	}
}
