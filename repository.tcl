package require sqlite3

namespace eval repo {}

proc ::repo::create {} {
	file mkdir data
	sqlite3 fileRepo ./data/repo.sqlite -create true

	fileRepo eval { create table if not exists t1(a int, b text) }
}
