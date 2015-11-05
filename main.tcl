if {$tcl_version < 8.6} {
	puts stderr {This application requires Tcl version 8.6 or higher}
	exit 1
}

package require tanzer 0.1
package require tanzer::file::handler

source ./repository.tcl
source ./lib/simple-templater.tcl

::repo::create

set server [::tanzer::server new]

$server route GET /api {localhost:8080} apply {
	{event session args} {
		if {$event ne "write"} {
			return
		}
		set response [::tanzer::response new 200 {
			Content-Type "application/json"
		}]

		$response buffer {{"json":true}}

		$session send $response
		$session nextRequest
	}
}

$server route POST /api/file {localhost:8080} apply {
	{event session {data ""}} {
		switch -- $event "read" {
			puts $data
			return
		} "write" {
			set response [::tanzer::response new 200 {
				Content-Type "text/plain"
			}]
			$response buffer "got $data"
			$session send $response
			$session nextRequest
		}
	}
}

$server route GET /file {localhost:8080} apply {
	{event session args} {
		if {$event ne "write"} return
		set response [::tanzer::response new 200 {
			Content-Type "text/html"
		}]

		set fp [open "public/file-details.html" r]
		set template [read $fp]
		close $fp

		$response buffer [::simp-templer::render {name myfile.txt upload-date 2015-11-02} $template]

		$session send $response
		$session nextRequest
	}
}

$server route GET /* {localhost:8080} [::tanzer::file::handler new [list root ./public]]

$server listen 8080
