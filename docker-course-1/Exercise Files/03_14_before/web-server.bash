#!/usr/bin/env bash

start_server() {
  echo "Server started. Visit http://localhost:8080 to use it."
  message=$(echo "<html><body><p>Hello! Today's date is $(date).</p></body></html>")
  length=$(wc -c <<< "$message")
  payload="\
HTTP/1.1 200 OK
Content-Length: $((length-1))

$message"
  while true
  do echo -ne "$payload" | nc -l -p 8080
  done
}

start_server
