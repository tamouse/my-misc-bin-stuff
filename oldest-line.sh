#!/bin/bash
for file in $(find . -type f|grep -Ev '^\./\.');
do
  git blame --date=format:%Y%m%d $file 2>/dev/null
done | sed -e 's/.*\s\([0-9]\{8\}\)\s.*/\1/' | sort -r | tail
