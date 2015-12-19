#!/bin/bash
set -xv
: ${WIDTH:=1024}
: ${DIR:=webs}
mkdir -p $DIR && mogrify -verbose -path $DIR -resize $WIDTH -quality 60 *.jpg *.png *.gif
