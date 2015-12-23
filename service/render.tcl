package require mustache

namespace eval ::render {
	set fp [open "template/file-details.html" r]
	variable fileDetailsTmpl [read $fp]
	close $fp

	set fp [open "template/index.html" r]
	variable indexTmpl [read $fp]
	close $fp
}

source ./service/repository.tcl

proc ::render::index {} {
	variable indexTmpl
	set fileList [::repo::getuploads]
	return [::mustache::mustache $indexTmpl [list files $fileList]]
}

proc ::render::fileDetails {fileId} {
	variable fileDetailsTmpl
	set fileMetadata [::repo::getobject uploads $fileId]
	return [::mustache::mustache $fileDetailsTmpl $fileMetadata]
}
