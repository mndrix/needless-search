// +build darwin

package environment

func (*Environment) IsMdfindAvailable() bool {
	return true
}
