#!/bin/bash
while IFS=, read -r port password; do
  docker stop dobc-"${port}"
  docker stop mysql-"${port}"
done < "$1"
