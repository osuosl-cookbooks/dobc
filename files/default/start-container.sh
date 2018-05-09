#!/bin/bash
while IFS=, read -r port password ; do
  if [ "$2" == "$port" ] ; then
    docker run \
      -p "330${port}":22 \
      -p "340${port}":8080 \
      -h dobc --rm -e DOBC_PASSWORD="${password}" \
      --name=dobc-"${port}" -d \
      --device-write-bps /dev/vda:20mb \
      osuosl/dobc-centos
  fi
done < "$1"
