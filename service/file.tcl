namespace eval fileservice {}

source ./service/repository.tcl

proc fileservice::getfile {id} {
	set data [::repo::getobject uploads $id]
	return [dict create filename [dict get $data name] contents [dict get $data blob]]
}

proc fileservice::add {} {
}
