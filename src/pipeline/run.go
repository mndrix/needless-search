package pipeline

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"strconv"
	"strings"
	"syscall"

	"environment"
)

func (p *Pipeline) Run() error {
	// can 'git grep' handle the entire pipeline?
	if p.env.IsInGitRepository() {
		commands := make([][]string, 1)
		needle, _ := p.s.Needle()
		commands[0] = []string{
			"git", "grep",
			"--untracked",
			"-I", // don't match pattern in binary files
			"-H", // include filename for each match
			"-n", // include line number for each match
			"--color",
			"-e", needle,
		}
		return run(p.env, commands)
	}

	// can't use git; build pipeline from multiple commands
	commands := make([][]string, 2)
	commands[0] = p.h.AsBash()

	commands[1] = append(fanout(), p.s.AsBash()...)

	return run(p.env, commands)
}

func fanout() []string {
	cpuCount := runtime.NumCPU()

	return []string{
		"xargs",
		"-0",
		"-n", "1000",
		"-P", strconv.Itoa(cpuCount),
	}
}

func run(env *environment.Environment, commands [][]string) error {
	// create each command in the pipeline
	cmds := make([]*exec.Cmd, 0, len(commands))
	for _, command := range commands {
		name := command[0]
		cmds = append(cmds, exec.Command(name, command[1:len(command)]...))
	}

	// connect adjacent pipleline commands
	buf := new(bytes.Buffer)
	finalI := len(cmds) - 1
	for i, cmd := range cmds {
		var err error
		cmd.Stderr = os.Stderr

		// output command we're running; for debugging
		if i > 0 {
			buf.WriteString(" | ")
		}
		buf.WriteString(strings.Join(commands[i], " "))

		// final command in the pipeline is special
		if i == finalI {
			cmd.Stdout = os.Stdout
			continue
		}

		cmds[i+1].Stdin, err = cmd.StdoutPipe()
		if err != nil {
			return err
		}
	}
	env.Header(os.Stderr, buf.String())

	// start each process in the pipeline running
	for _, cmd := range cmds {
		err := cmd.Start()
		if err != nil {
			if e, ok := err.(*exec.Error); ok {
				format := "Couldn't find a tool needed by our query plan\n" +
					"Perhaps you need to install '%s'\n" +
					"%s\n"
				fmt.Fprintf(os.Stderr, format, e.Name, err.Error())
				os.Exit(1)
			} else {
				panic(err)
			}
		}
	}

	// wait for each pipeline component to stop
	for i := len(cmds) - 1; i >= 0; i-- {
		err := cmds[i].Wait()
		if err != nil {
			if commands[i][0] == "xargs" {
				if status, ok := exitStatus(err); ok {
					if status == 123 {
						// one of the greps found no matches. that's expected
						continue
					}
				}
			}
			return nil
		}
	}

	return nil
}

// exitStatus returns the exit status and true if this error represents a
// non-0 exit status; otherwis, returns false.
func exitStatus(err error) (int, bool) {
	if err == nil {
		return 0, false
	}

	if e, ok := err.(*exec.ExitError); ok {
		if status, ok := e.Sys().(syscall.WaitStatus); ok {
			return status.ExitStatus(), true
		}
	}

	return 0, false
}
