namespace eval simp-templer {}

proc ::simp-templer::render {data template} {
	set mapping [dict create]
	foreach key [dict keys $data] {
		dict set mapping "{{$key}}" [dict get $data $key]
	}
	return [string map $mapping $template]
}
