#!/bin/bash

#reference: https://www.bytebase.com/docs/get-started/self-host/#docker
set -xe

docker run -d --rm --init \
	--name bytebase \
	--publish 8080:8080 --pull always \
	--volume ~/.bytebase:/var/opt/bytebase \
	bytebase/bytebase:2.16.0
#       cyching/bytebase:2.16.0-fmt-0510-2
