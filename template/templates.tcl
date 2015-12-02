namespace eval templates {
  proc file-details {} {
  return "
    <html>
    <body>
    <h1>File details:</h1>
    <p>Name: {{name}}</p>
    <p>Description: {{description}}</p>
    <p>Date uploaded: {{created_at}}</p>

    <div>id: {{id}}</div>
    <div>name: {{name}}</div>
    <div>votes: {{votes}}</div>
    <div>type: {{type}}</div>
    <div>description: {{description}}</div>
    <div>tags: {{tags}}</div>
    <div>blob: {{blob}}</div>
    <div>uploader: {{uploader}}</div>
    <div>programs_id: {{programs_id}}</div>
    <div>created_at: {{created_at}}</div>
    <div>modified_at: {{modified_at}}</div>

    </body>
    </html>"
  }
}
