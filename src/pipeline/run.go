package pipeline

import (
	"fmt"
	"os"
	"os/exec"
)

func (p *Pipeline) Run() error {
	commands := make([][]string, 2)
	commands[0] = p.h.AsBash()

	commands[1] = append(Fanout(), p.s.AsBash()...)

	return run(commands)
}

func run(commands [][]string) error {
	// create each command in the pipeline
	cmds := make([]*exec.Cmd, 0, len(commands))
	for _, command := range commands {
		name := command[0]
		cmds = append(cmds, exec.Command(name, command[1:len(command)]...))
	}

	// connect adjacent pipleline commands
	finalI := len(cmds) - 1
	for i, cmd := range cmds {
		var err error
		cmd.Stderr = os.Stderr

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
			return err
		}
	}

	return nil
}
