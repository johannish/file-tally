source ../repository.tcl

::repo::create

::repo::insert uploads
#{'test.config' 'this is a configuration file for test.exe' '.config' 'jordan miller' 'unknown' 'tcl test config stuff' 1 1 '20151031 14:18:00' '20151031 14:18:00'}

#uploads(filename string, description text, type string, uploader string, blob blob, tags text, votes int, program_id int, created_at datetime, modified_at datetime) }
#programs(name string, description text, version string, tags text, created_at datetime, modified_at datetime) }
