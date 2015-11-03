source ../repository.tcl

#create databse
::repo::create

#insert tablename dictionary(col, data)
::repo::insert uploads {name "Tcl's File" description "This is a file" type "config file" uploader "jordanMiller" blob "001010111010101010" tags "configs, other tags, etc." votes "1" programs_id "1"}
::repo::insert uploads {name "TK's File" description "This is a file" type "config file" uploader "jordanMiller" blob "001010111010101011" tags "configs, other tags, etc." votes "1" programs_id "1"}
::repo::insert programs {name "Tcl" description "This is a program" version "8.6.4" tags "tcl, programming language" uploads_id "1"}
#update tablename rowid dictionary(col, data)
::repo::update uploads 1 {name "8" description "2" type "3" uploader "4" blob "5" tags "6" votes "7" programs_id "1"}

##query

#getspecific tablename rowid columnname
puts [::repo::getspecific uploads 1 type]
#getobject tablename rowid columnname
puts [::repo::getobject uploads 1]
#getprogramconfigs rowid
puts [::repo::getprogramuploads 1]
#getuploadprogram rowid
puts [::repo::getuploadprograms 1]

##delete table id
::repo::delete uploads 2
