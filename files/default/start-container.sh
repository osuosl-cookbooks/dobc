#!/bin/bash
while IFS=, read -r port password ; do
  if [ "$2" == "$port" ] ; then
    docker run -p "${port}":22 -h dobc --rm -e DOBC_PASSWORD="${password}" \
      --name=dobc-"${port}" -d \
      --device-write-bps /dev/vda:20mb \
      -c 10 -m 128m \
      osuosl/dobc-centos
  fi
done < "$1"
