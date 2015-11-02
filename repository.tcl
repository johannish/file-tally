package require sqlite3

namespace eval repo {}

proc ::repo::create {} {
	file mkdir data
	sqlite3 fileRepo ./data/repo.sqlite -create true

	fileRepo eval { create table if not exists uploads(name string, description text, type string, uploader string, blob blob, tags text, votes int, program_id int, created_at datetime, modified_at datetime) }
	fileRepo eval { create table if not exists programs(name string, description text, version string, tags text, created_at datetime, modified_at datetime) }
}

#data should be a list void of commas. we put in the commas in this proc
proc ::repo::insert {table coldata} {
	#set dictionary [dictmerge $cols $datas]

	if [dict exists $coldata name] {
		set name [dict get $coldata name]
	}
	if [dict exists $coldata description] {
		set description [dict get $coldata description]
	}
	if [dict exists $coldata description] {
		set type [dict get $coldata type]
	}
	if [dict exists $coldata uploader] {
		set uploader [dict get $coldata uploader]
	}
	if [dict exists $coldata blob] {
		set blob [dict get $coldata blob]
	}
	if [dict exists $coldata tags] {
		set tags [dict get $coldata tags]
	}
	if [dict exists $coldata votes] {
		set votes [dict get $coldata votes]
	}
	if [dict exists $coldata program_id] {
		set program_id [dict get $coldata program_id]
	}
	#Porgrams
	if [dict exists $coldata version] {
		set version [dict get $coldata version]
	}
	#datetime
	if [dict exists $coldata created_at] {
		set created_at [dict get $coldata created_at]
	} else {
		set created_at [clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"]
	}
	if [dict exists $coldata modified_at] {
		set modified_at [dict get $coldata modified_at]
	} else {
		set modified_at [clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"]
	}

	switch $table {
    uploads {
        #fileRepo eval {INSERT INTO uploads (filename) VALUES ($filename,$description);	}
				fileRepo eval {INSERT INTO uploads VALUES ($name,$description,$type,$uploader, $blob, $tags, $votes, $program_id, $created_at, $modified_at)}
    }
    programs {
        fileRepo eval {INSERT INTO programs VALUES($name,$description,$version,$tags,$created_at,$modified_at)}
    }
    default {
			fileRepo eval {INSERT INTO uploads VALUES ($name,$description,$type,$uploader, $blob, $tags, $votes, $program_id, $created_at, $modified_at)}
    }
	}

}

#can only take one entry at a time at this point
proc ::repo::update {table id coldata} {
	#recursive because I only know how to do one update at a time with one value.
	#so pop off each column, and each data point, and update the database

	if {$coldata eq {}} then {
		return
	} elseif {[expr fmod([llength $coldata],2)] > 0} {
		return "submitted data must be a dictionary."
	}
	set col [lindex $coldata 0]
	set data [lindex $coldata 1]
	set coldatas [lreplace $coldata 0 1]
	switch $table {
		uploads {
			fileRepo eval "UPDATE uploads SET $col=$data WHERE rowid=$id"
		}
		programs {
			fileRepo eval "UPDATE programs SET $col=$data WHERE rowid=$id"
		}
		default {
			fileRepo eval "UPDATE uploads SET $col=$data WHERE rowid=$id"
		}
	}
	::repo::update $table $id $coldatas
}

#can only delete according to row at this point
proc ::repo::delete {table id} {
	fileRepo eval {DELETE FROM $table WHERE rowid=$id;}
}

proc ::repo::read {table id} {
	#db eval "SELECT component FROM $table WHERE LC = :lc" {
  #  puts "component = $component"
	#}
}

#flesh out index.html to show a list of files,
#dynamically create index.html on the server- put place holders in it to read data from data base and fill it.
#index.html is just a template
#https://github.com/ianka/mustache.tcl
#http://tanzer.io/git/teaspoon.git

#create a better table - date, votes, filename, type, tags, description, blob file
#test script - sources repository.tcl and inserts a file into the database - line 5 to create a better table
#create another proc to add file - that would be the one test script would call.
#in test script - calls addfile(type and description), then file stuff,

#branch:
# after commit
#git checkout -b jordan
#git push -u origin jordan
