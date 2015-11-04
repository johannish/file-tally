source ./trimrepos.tcl

#create databse
::repo::create

::repo::dostuff

set x 0
while {$x < 1000} {
  ::repo::dostuff
  set x [expr $x + 1]
}
#set x 0
#while {$x < 1000} {
#  ::repo::insert uploads {"1"}
#  set x [expr $x + 1]
#}
