#!/bin/bash
set -xv
: ${THUMBSIZE:=200}
: ${THUMBNAIL:=${THUMBSIZE}x${THUMBSIZE}}
mkdir -p thumbs && mogrify -verbose -format gif -path thumbs -thumbnail ${THUMBNAIL}^ -gravity center -extent ${THUMBNAIL} *.jpg *.png *.gif
