set a {.tcl "Tcl File"}
set b {.txt "Text File"}

set c {.tcl .txt}
set d {"Tcl File" "Text File"}


set first [list {*}$a {*}$b]
puts $first

set x {}
foreach i $c j $d {
    lappend x $i $j
}
puts $x

puts [dict exists $x .tcl]


puts [expr round([expr fmod(25,5)])]
