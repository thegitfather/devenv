#!/bin/bash

dir="."
count=""

if [ "$#" -eq "0" ]; then
  :
elif [ "$#" -eq "1" ]; then
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    count="$1"
  else
    dir="$1"
  fi
elif [ "$#" -eq "2" ]; then
  dir="$1"
  count="$2"
else
  echo "Usage: lastmod [<dir>|<count>] [<count>]"
  exit 1
fi

if [ -n "$count" ]; then
  find "$dir" -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head -"$count"
else
  find "$dir" -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head
fi