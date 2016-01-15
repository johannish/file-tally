package require ncgi 1.4

namespace eval ::form {
}

# description {{content-disposition form-data name description} moo} upload {{content-disposition form-data name upload filename dark.css content-type text/css} {}}

# Returns a single value (form value)
proc getFormVal {form field} {
	return [lindex [dict get $form $field] 1]
}

# Returns a dictionary of metadata
proc getFieldMetadata {form field} {
	return [lindex [dict get $form $field] 0]
}

proc ::form::parseUpload {contentType formData} {
	set parsed [::ncgi::multipart $contentType $formData]

	set upload [dict create]
	dict append upload {description} [getFormVal $parsed description]
	dict append upload {blob} [getFormVal $parsed upload] ;#TODO rename to content
	dict append upload {name} [dict get [getFieldMetadata $parsed upload] filename]
	dict append upload {type} [dict get [getFieldMetadata $parsed upload] content-type]

	#puts "UPLOAD: $upload"
	return $upload
}
