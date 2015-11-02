source ../repository.tcl

::repo::create

#insert tablename dictionary(col, data)
::repo::insert uploads {name "Tcl File" description "This is a file" type "config file" uploader "jordanMiller" blob "001010111010101010" tags "configs, other tags, etc." votes "1" program_id "1"}
#update tablename rowid dictionary(col, data)
::repo::update uploads 1 {name "1" description "2" type "3" uploader "4" blob "5" tags "6" votes "7" program_id "8"}
#read tablename rowid columnname
puts [::repo::read uploads 1 type]
