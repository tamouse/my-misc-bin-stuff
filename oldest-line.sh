#!/bin/bash

# so this little tune was so i could prove a point about the age of code in a project i
# was working on. I'm sure there are much better ways to figure this out, but this was
# about 10-15 minutes. The grep on the first line was because I wanted to ignore dot files
# in each folder.

for file in $(find . -type f|grep -Ev '^\./\.');
do
  git blame --date=format:%Y%m%d $file 2>/dev/null
done | sed -e 's/.*\s\([0-9]\{8\}\)\s.*/\1/' | sort -r | tail
