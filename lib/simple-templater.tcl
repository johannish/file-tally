namespace eval ::simp-templer {}

proc ::simp-templer::render {data template} {
	set mapping [dict map {key val} $data {
		set key "{{$key}}"
		set val
	}]
	return [string map $mapping $template]
}
