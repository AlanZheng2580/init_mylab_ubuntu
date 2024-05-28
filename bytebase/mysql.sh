#!/bin/bash

WORKSPACE_TSMC=~/workspace/tsmc
docker run --rm -v ${WORKSPACE_TSMC}/mysqldatatest:/var/lib/mysql -v ${WORKSPACE_TSMC}/my.cnf:/etc/my.cnf --name mysql-test -p 3307:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:5.7
docker run --rm -v ${WORKSPACE_TSMC}/mysqldataprod:/var/lib/mysql -v ${WORKSPACE_TSMC}/my.cnf:/etc/my.cnf --name mysql-prod -p 3308:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:5.7
