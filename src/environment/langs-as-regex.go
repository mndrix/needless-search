package environment

import (
	"fmt"
	"strings"
)

// WantsSpecificLanguages returns true if the environment has requested
// that only certain languages be searched.
func (env *Environment) WantsSpecificLanguages() bool {
	return len(env.Languages) > 0
}

// LangsAsRegexString computes a regular expression which matches
// files in those languges requested by the environment.
func (env *Environment) LangsAsRegexString() string {
	extensions := make([]string, 0)
	filenames := make([]string, 0)
	parts := make([]string, 0)

	// collect desired extenions and filenames
	for _, lang := range env.Languages {
		extensions = append(extensions, lang.Extensions...)
		filenames = append(filenames, lang.Filenames...)
	}

	// handle known extension names
	if len(extensions) > 0 {
		alternatives := strings.Join(extensions, "|")
		re := fmt.Sprintf("[.](%s)$", alternatives)
		parts = append(parts, re)
	}

	// handle known file names
	if len(filenames) > 0 {
		alternatives := strings.Join(filenames, "|")
		re := fmt.Sprintf("/(%s)$", alternatives)
		parts = append(parts, re)
	}

	alternatives := strings.Join(parts, "|")
	return fmt.Sprintf("(%s)", alternatives)
}
