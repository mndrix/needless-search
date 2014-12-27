// +build linux

package environment

func (*Environment) IsMdfindAvailable() bool {
	return false
}
