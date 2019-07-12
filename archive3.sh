#!/bin/bash
#
# NAME
#
# archive3.sh - sync up a directory (in $1) to my current saving spaces
#
# SYNOPSIS
#
#     $HOME/bin/archive3.sh DIR/
#
# DESCRIPTION
#
# This script saves a directory, specified in $1, to a set of backup locations, local and remote.
#
# The spaces currently consist of the following paths:
#
# 1. /Volumes/My Book 4TB/
# 2. /Volumes/Seagate 4TB/
# 3. s3://tt-archive
#
# The way the arhicves are set up should mirror the tree from the specified directory down. To use this, you'll need to `cd` to the **PARENT** directory to issue the command.
#
# EXAMPLES
#
# Saving Books
#
#     $ cd $HOME
#     $ archive3.sh Books/
#
# Note the trailing slash is **required** for this to work properly.
#
# Saving Latest photos from Nikon upload:
#
#     $ cd ~/GoogleDrive/
#     $ archive3.sh Pictures/MyPhotos/nikond5000/
#
# This will copy to the same directory path on the various spaces.
#
# TODO
#
# Figure out how to automate this somehow without causing a huge drag on the system and network.

: ${MY_BOOK:="/Volumes/My Book 4TB"}
: ${SEAGATE:="/Volumes/Seagate 4TB"}
: ${TT_ARCHIVE:="s3://tt-archive"}

if [ ! -d "$1" ] ; then
    echo "- $1 - is not a directory"
    exit -1
fi

EXCLUDES_PATH="$HOME/.rsync-excludes"
RSYNC=`which rsync`
RSYNC_OPTS="-avz --exclude-from=$EXCLUDES_PATH"

$RSYNC $RSYNC_OPTS "$1" "$MY_BOOK/$1"
$RSYNC $RSYNC_OPTS "$1" "$SEAGATE/$1"

S3SYNC_CMD=`which s3cmd`
S3EXCLUDES_PATH="$HOME/.s3sync-excludes"
S3SYNC_OPTS="--recursive --skip-existing --rexclude-from=$S3EXCLUDES_PATH sync"

$S3SYNC_CMD $S3SYNC_OPTS "$1" "$TT_ARCHIVE/$1"
