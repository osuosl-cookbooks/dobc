#!/bin/bash
while IFS=, read -r port password; do
  docker stop dobc-"${port}"
done < "$1"
