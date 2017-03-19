#!/bin/bash


if [! -d "$1"] ; then
    echo "- $1 - is not a directory"
    exit -1
fi

if [! -d "$2"] ; then
    echo "- $2 - is not a directory"
    exit -2
fi

EXCLUDES_PATH=$HOME/.rsync-excludes
RSYNC=`which rsync`
RSYNC_OPTS='-avz --progress'

$RSYNC $RSYNC_OPTS --exclude-from=$EXCLUDES_PATH $1 $2
