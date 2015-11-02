namespace eval simp-templer {}

proc ::simp-templer::render {data template} {
	set nameVal [dict get $data name]
    #regsub -all {{{(.*)??}}} "{{cat}}{{car}}" {[dict get $data \1]}
	return [regsub -all "{{name}}" $template $nameVal]
}
