#!/bin/bash

set -e
echo ${1%%.*}
pandoc --wrap=none -o ${1%%.*}.org $1
/bin/ls -1 ${1%%.*}*
