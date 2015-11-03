source ./trimrepos.tcl

#create databse
::repo::create

set x 0
while {$x < 1000} {
  ::repo::insert uploads {"1"}
  set x [expr $x + 1]
}
