source ../repository.tcl

::repo::create

::repo::insert uploads {name "Tcl File" description "This is a file" type "config file" uploader "jordanMiller" blob "001010111010101010" tags "configs, other tags, etc." votes "1" program_id "1"}



#{'test.config', 'this is a configuration file for test.exe', '.config', 'jordan miller', 'unknown', 'tcl test config stuff', 1, 1, '20151031 14:18:00', '20151031 14:18:00'}
#puts [::repo::update uploads 1 {filename description} {"hello.tcl" "you suck"}]
puts [::repo::update uploads 2 {name "1" description "2" type "3" uploader "4" blob "5" tags "6" votes "7" program_id "8"}]

#uploads(filename string, description text, type string, uploader string, blob blob, tags text, votes int, program_id int, created_at datetime, modified_at datetime) }
#programs(name string, description text, version string, tags text, created_at datetime, modified_at datetime) }
