if {$tcl_version < 8.6} {
	puts stderr {This application requires Tcl version 8.6 or higher}
	exit 1
}

package require tcltest

::tcltest::configure -file {"*.test.tcl"} -notfile {}
::tcltest::runAllTests
