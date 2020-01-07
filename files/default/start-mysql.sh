#!/bin/bash
while IFS=, read -r port password ; do
  if [ "$2" == "$port" ] ; then
    docker run -d --rm \
      --name=mysql-"${port}" \
      -e MYSQL_ROOT_PASSWORD=dobc \
      -e MYSQL_INITDB_SKIP_TZINFO=1 \
      mariadb:10.4 \
      --key_buffer=16M \
      --innodb_buffer_pool_size=32M \
      --query_cache_size=16M \
      --sort_buffer=1M \
      --read_buffer=60K \
      --tmp_table=8M \
      --max_connections=10
  fi
done < "$1"
