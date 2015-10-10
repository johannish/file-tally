package require tanzer 0.1
package require tanzer::file::handler

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

$server route GET /* {localhost:8080} [::tanzer::file::handler new [list root ./public]]

$server listen 8080
