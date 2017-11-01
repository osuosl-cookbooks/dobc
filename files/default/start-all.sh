#!/bin/bash
while IFS=, read -r port password ; do
  docker run -p "${port}":22 -h dobc --rm -e DOBC_PASSWORD="${password}" \
    --name=dobc-"${port}" -d \
    --device-write-bps /dev/vda:10mb \
    -c 10 -m 128m \
    osuosl/dobc-centos
done < "$1"
