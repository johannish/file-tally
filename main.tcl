if {$tcl_version < 8.6} {
	puts stderr {This application requires Tcl version 8.6 or higher}
	exit 1
}

package require tanzer 0.1
package require tanzer::file::handler
package require ncgi 1.4

source ./service/repository.tcl
source ./service/render.tcl
source ./service/form.tcl
source ./service/file.tcl

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
			append currentdata [$session store data] $data
			$session store data $currentdata
			if {[$session requestBodyFinished]} {
				set contentType [dict get [[$session request] headers] Content-Type]
				set upload [::form::parseUpload $contentType [$session store data]]
				set id [::repo::insert uploads $upload]
				$session store newId $id
			}

			return
		} "write" {
			set response [::tanzer::response new 302 [
				list Location /file-details/[$session store newId]
			]]
			$session send $response
			$session nextRequest
		}
	}
}

$server route GET /api/file/:id {localhost:8080} apply {
	{event session args} {
		if {$event ne "write"} return

		set id [[$session request] param id]
		set data [fileservice::getfile $id]

		set response [::tanzer::response new 200 [
			list Content-Disposition "attachment; filename=[dict get $data filename]"
		]]

		$response buffer [dict get $data contents]

		$session send $response
		$session nextRequest
	}
}

$server route GET /file-details/:file-id {localhost:8080} apply {
	{event session args} {
		if {$event ne "write"} return
		set response [::tanzer::response new 200 {
			Content-Type "text/html"
		}]

		set fileId [[$session request] param {file-id}]
		$response buffer [::render::fileDetails $fileId]

		$session send $response
		$session nextRequest
	}
}

$server route GET / {localhost:8080} apply {
	{event session args} {
		if {$event ne "write"} return
		set response [::tanzer::response new 200 {
			Content-Type "text/html"
		}]

		$response buffer [::render::index]

		$session send $response
		$session nextRequest
	}
}

$server route GET /static/* {localhost:8080} [::tanzer::file::handler new [list root ./public listings 1]]

puts {about to listen on http://localhost:8080}
$server listen 8080
