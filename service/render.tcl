package require mustache

namespace eval ::render {
	set fp [open "template/file-details.html" r]
	variable fileDetailsTmpl [read $fp]
	close $fp

	set fp [open "template/index.html" r]
	variable indexTmpl [read $fp]
	close $fp
}

source ./repository.tcl
source ./lib/simple-templater.tcl

proc ::render::index {} {
	variable indexTmpl
	return [::simp-templer::render {files {Here should be a list of files. It's time to use a real template spec, like mustache}} $indexTmpl]
}

proc ::render::fileDetails {fileId} {
	variable fileDetailsTmpl
	set fileMetadata [::repo::getobject uploads $fileId]
	return [::mustache::mustache $fileDetailsTmpl $fileMetadata]
}
