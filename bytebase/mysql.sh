#!/bin/bash

docker run -v ~/mysqldatatest:/var/lib/mysql -v ~/my.cnf:/etc/my.cnf --name mysql-test -p 3307:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:5.7
docker run -v ~/mysqldataprod:/var/lib/mysql -v ~/my.cnf:/etc/my.cnf --name mysql-prod -p 3308:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:5.7
