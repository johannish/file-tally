package require tcltest

source ../repository.tcl

::tcltest::test insert_uploads_returnsId {
} -setup {
	::repo::create
} -body {
	set first [::repo::insert uploads {name "name"}]
	set second [::repo::insert uploads {name "name"}]
	set third [::repo::insert uploads {name "name"}]
	return "$first $second $third"
} -cleanup {
	exec rm -rf ./data/repo.sqlite
} -result {1 2 3}

::tcltest::test insert_programs_returnsId {
} -setup {
	::repo::create
} -body {
	set first [::repo::insert programs {name "name"}]
	set second [::repo::insert programs {name "name"}]
	set third [::repo::insert programs {name "name"}]
	return "$first $second $third"
} -cleanup {
	exec rm -rf ./data/repo.sqlite
} -result {1 2 3}

::tcltest::test insert_addsSparseDataCorrectly {
} -setup {
	::repo::create
} -body {
	set id [::repo::insert uploads {name "filename1" type "type1"}]
	set outcome [::repo::getobject uploads $id]
	#puts "DEBUG: $outcome"
	return [expr {
		[dict get $outcome name] == {filename1}
		&& [dict get $outcome type] == {type1}
		&& [dict get $outcome description] == {}
	}]
} -cleanup {
	exec rm -rf ./data/repo.sqlite
} -result 1

::tcltest::test insert_addsSingleItemCorrectly {
} -setup {
	::repo::create
} -body {
	set id [::repo::insert uploads {name "filename1" description "description1" type "type1" uploader "uploader1" blob "0010101110" tags "tag1, tag2" votes "vote1" programs_id "pid1"}]
	set outcome [::repo::getobject uploads $id]
	#puts "DEBUG: $outcome"
	return [expr {
		[dict get $outcome name] == {filename1}
		&& [dict get $outcome description] == {description1}
		&& [dict get $outcome type] == {type1}
		&& [dict get $outcome uploader] == {uploader1}
		&& [dict get $outcome blob] == {0010101110}
		&& [dict get $outcome tags] == {tag1, tag2}
	}]
} -cleanup {
	exec rm -rf ./data/repo.sqlite
} -result 1

::tcltest::test update_updatesSingleItemCorrectly {
} -setup {
	::repo::create
	set id [::repo::insert uploads {name "filename" uploader "uploader" votes "votes"}]
} -body {
	::repo::update uploads $id {name "update_name1" uploader "update_uploader1" votes "update_vote1" }
	set outcome [::repo::getobject uploads $id]
	#puts $outcome
	return [expr {
		[dict get $outcome name] == {update_name1}
		&& [dict get $outcome uploader] == {update_uploader1}
		&& [dict get $outcome votes] == {update_vote1}
	}]
} -cleanup {
	exec rm -rf ./data/repo.sqlite
} -result 1

::tcltest::test update_handlesSingleQuotes {
} -setup {
	::repo::create
	set id [::repo::insert uploads {name "filename" uploader "uploader" votes "votes"}]
} -body {
	::repo::update uploads $id {uploader "john's file isn't always the only one" }
	set outcome [::repo::getobject uploads $id]
	#puts $outcome
	return [expr {[dict get $outcome uploader] == {john's file isn't always the only one}}]
} -cleanup {
	exec rm -rf ./data/repo.sqlite
} -result 1


::tcltest::cleanupTests