namespace eval ::render {
	set fp [open "public/file-details.html" r]
	variable fileDetailsTmpl [read $fp]
	close $fp
}

source ./repository.tcl
source ./lib/simple-templater.tcl

proc ::render::fileDetails {fileId} {
	variable fileDetailsTmpl
	set fileMetadata [::repo::getobject uploads $fileId]
	return [::simp-templer::render $fileMetadata $fileDetailsTmpl]
}
