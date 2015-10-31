package require sqlite3

namespace eval repo {}

proc ::repo::create {} {
	file mkdir data
	sqlite3 fileRepo ./data/repo.sqlite -create true

	fileRepo eval { create table if not exists uploads(filename string, description text, type string, uploader string, blob blob, tags text, votes int, program_id int, created_at datetime, modified_at datetime) }
	fileRepo eval { create table if not exists programs(name string, description text, version string, tags text, created_at datetime, modified_at datetime) }
}

#data should be a list void of commas. we put in the commas in this proc
proc ::repo::insert {table} {
	#easy way:
	#fileRepo eval {INSERT INTO $table VALUES($data)}

	#if $data is a list and doesn*t have commas we need to add them:
	#fileRepo eval {INSERT INTO $table VALUES([join [foreach item $data { $item }] , ])}
	puts $table
	#problem with substitution here
	fileRepo eval {INSERT INTO $table VALUES('filename')}
}

#can only take one entry at a time at this point
proc ::repo::update {table id col data} {
	fileRepo eval {UPDATE $table SET $col=$data WHERE rowid=$id;}
}

#can only delete according to row at this point
proc ::repo::delete {table id} {
	fileRepo eval {DELETE FROM $table WHERE rowid=$id;}
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
