package require sqlite3

namespace eval repo {}

proc ::repo::create {} {
	file mkdir data
	sqlite3 fileRepo ./data/repo.sqlite -create true

	fileRepo eval {
		create table if not exists uploads(id INTEGER PRIMARY KEY AUTOINCREMENT
			,name text
			,description text
			,type text
			,uploader text
			,blob blob
			,tags text
			,votes int
			,programs_id int
			,created_at datetime
			,modified_at datetime)
	}
	fileRepo eval {
		create table if not exists programs(id INTEGER PRIMARY KEY AUTOINCREMENT
			,name text
			,description text
			,version text
			,tags text
			,uploads_id int
			,created_at datetime
			,modified_at datetime)
	}
}

proc ::repo::insert {table coldata} {

	if [dict exists $coldata name] {
		set name [dict get $coldata name]
	}
	if [dict exists $coldata description] {
		set description [dict get $coldata description]
	}
	if [dict exists $coldata type] {
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
	if [dict exists $coldata programs_id] {
		set programs_id [dict get $coldata programs_id]
	}
	#programs
	if [dict exists $coldata version] {
		set version [dict get $coldata version]
	}
	if [dict exists $coldata uploads_id] {
		set uploads_id [dict get $coldata uploads_id]
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
			fileRepo eval {INSERT INTO uploads VALUES ($id, $name,$description,$type,$uploader, $blob, $tags, $votes, $programs_id, $created_at, $modified_at)}
			return [fileRepo eval {SELECT last_insert_rowid()}]
		}
		programs {
			fileRepo eval {INSERT INTO programs VALUES($id, $name,$description,$version,$tags,$uploads_id,$created_at,$modified_at)}
			return [fileRepo eval {SELECT last_insert_rowid()}]
		}
		default {
			return [fileRepo eval {INSERT INTO uploads VALUES ($name,$description,$type,$uploader, $blob, $tags, $votes, $programs_id, $created_at, $modified_at)}]
		}
	}
}

proc ::repo::update {table id coldata} {

	if {$coldata eq {}} then {
		return $id
	} elseif {[expr fmod([llength $coldata],2)] > 0} {
		return "submitted data must be a dictionary."
	} elseif {[string match *''* $coldata]} {
	} elseif {[string match *'* $coldata]} {
		regsub -all  "'" $coldata "''" coldata
	}

	if ![dict exists $coldata modified_at] {
		set modified_at [clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"]
		dict set $coldata modified_at $modified_at
	}

	set values ""
	foreach key [dict keys $coldata] {
		if {$values ne ""} { set values "$values," }
		set values "$values$key='[dict get $coldata $key]'"
	}
	fileRepo eval "UPDATE $table SET $values WHERE rowid=$id"
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
	return $id
}

proc ::repo::getspecific {table id col} {
	return [fileRepo eval "SELECT $col FROM $table WHERE rowid=$id"]
}

proc ::repo::getobject {table id} {
	fileRepo eval "select * from $table WHERE rowid=$id" rows {
		array unset rows {\*} ;#get rid of sqlite's weird list(*) value containing all column names
		return [array get rows]
	}
}

proc ::repo::getprogramuploads {id} {
	#make this into a list
	return [fileRepo eval "SELECT * FROM uploads WHERE programs_id=$id"]
}

#join -> join two tables
#SELECT *
#from programs left outer join uploads on programs.id = uploads.programs_id
proc ::repo::getuploadprograms {id} {
	#make this into a list
	return [fileRepo eval "SELECT * FROM programs WHERE rowid=$id"]
}

#getlast id
#SELECT last_insert_rowid()


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



#has modified option
#if {$hasmodified eq ""} {
#	if [dict exists $coldata modified_at] {
#		set hasmod 1
#	} else {
#		set hasmod 0
#		set modified_at [clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"]
#	}
#}
#
#switch $table {
#	uploads {
#		if {[llength $coldata < 3] && $hasmod == 0} {
