package require sqlite3

namespace eval repo {}

proc ::repo::create {} {
	file mkdir data
	sqlite3 fileRepo ./data/repotrim.sqlite -create true

	fileRepo eval { create table if not exists uploads(c1) }
}

proc ::repo::insert {table data} {
  fileRepo eval {INSERT INTO uploads VALUES ($data)}
}

#recursive because I only know how to do one update at a time with one value.
#so pop off each column, and each data point, and update the database
proc ::repo::update {table id coldata {index 0}} {

	if {$coldata eq {}} then {
		return
	} elseif {[expr fmod([llength $coldata],2)] > 0} {
		return "submitted data must be a dictionary."
	} elseif {[string match *''* $coldata]} {
	} elseif {[string match *'* $coldata]} {
		regsub -all  "'" $coldata "''" coldata
	}

	set col [lindex $coldata 0]
	set data [lindex $coldata 1]
	set coldatas [lreplace $coldata 0 1]
	set modified_at [clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"]

	switch $table {
		uploads {
			if {$index == 0} {
				fileRepo eval "UPDATE uploads SET modified_at='$modified_at' WHERE rowid=$id"
			}
			fileRepo eval "UPDATE uploads SET $col='$data' WHERE rowid=$id"
		}
		programs {
			if {$index == 0} {
				fileRepo eval "UPDATE programs SET modified_at='$modified_at' WHERE rowid=$id"
			}
			fileRepo eval "UPDATE programs SET $col='$data' WHERE rowid=$id"
		}
		default {
			if {$index == 0} {
				fileRepo eval "UPDATE uploads SET modified_at='$modified_at' WHERE rowid=$id"
			}
			fileRepo eval "UPDATE uploads SET $col='$data' WHERE rowid=$id"
		}
	}
	::repo::update $table $id $coldatas [expr $index + 1 ]
}

#can only delete according to row at this point
proc ::repo::delete {table id} {
	switch $table {
		uploads {
			fileRepo eval {DELETE FROM uploads WHERE rowid=$id;}
		}
		programs {
			fileRepo eval {DELETE FROM programs WHERE rowid=$id;}
		}
	}
}

proc ::repo::getspecific {table id col} {
	return [fileRepo eval "SELECT $col FROM $table WHERE rowid=$id"]
}

proc ::repo::getobject {table id} {
	return [fileRepo eval "SELECT * FROM $table WHERE rowid=$id"]
}

proc ::repo::getprogramuploads {id} {
	#make this into a list
	return [fileRepo eval "SELECT * FROM uploads WHERE programs_id=$id"]
}

proc ::repo::getuploadprograms {id} {
	#make this into a list
	return [fileRepo eval "SELECT * FROM programs WHERE rowid=$id"]
}
