#!/usr/bin/env bash

BASENAME=`basename "$0"`
TOTALMEM=0

if (( "$#" == 1 )); then
  while read -r line; do
    temp=$(echo "$line" | grep $1 | grep -o -E "[0-9]{2,}")
    TOTALMEM=$(( $temp+$TOTALMEM ))
  done < <(ps -eo comm,rsz ) # process substitution
else
  echo -e "Usage: $BASENAME <process name>\n"
  exit 1
fi

TOTALMEM=$(( $TOTALMEM / 1024 ))
echo "${TOTALMEM} MiB"

exit 0
