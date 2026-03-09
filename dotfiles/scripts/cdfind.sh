#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: cdfind <directory>"
  exit 1
fi

target=$(find . -type d -iname "*$1*" 2>/dev/null | head -1)

if [ -z "$target" ]; then
  echo "cdfind: no directory matching '$1' found"
  exit 1
fi

echo "$target"