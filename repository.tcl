package require sqlite3

namespace eval repo {}

proc ::repo::create {} {
	file mkdir data
	sqlite3 fileRepo ./data/repo.sqlite -create true

	fileRepo eval { create table if not exists t1(a int, b text) }
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
