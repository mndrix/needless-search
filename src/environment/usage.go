package environment

import (
	"fmt"
	"os"
)

func Usage() {
	fmt.Fprintf(os.Stderr, usageString)
}

const usageString = `Usage: ndl pattern
`
