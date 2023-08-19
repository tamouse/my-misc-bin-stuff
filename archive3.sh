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
# 1. ~~/Volumes/My Book 4TB/~~ DEAD
# 2. ~~/Volumes/Seagate 4TB/~~ DEAD
# 3. s3://tt-archive
#
# The way the arhicves are set up should mirror the tree from the specified directory
# down. To use this, you'll need to `cd` to the **PARENT** directory to issue the command.
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
# - [ ] Figure out how to automate this somehow without causing a huge drag on the system and network.

: ${TT_ARCHIVE:="s3://tt-archive"}

if [ ! -d "$1" ] ; then
    echo "- $1 - is not a directory"
    exit -1
fi

# NOTE: SWITCHING TO USE AWS INSTEAD OF S3CMD:
echo
echo "Backing up to S3"
aws s3 sync "$1" "$TT_ARCHIVE/$1" \
	    --exclude ".git/*" \
	    --exclude ".DS_Store" \
	    --exclude ".fseventsd/*" \
	    --exclude ".Spotlight*/*" \
	    --exclude ".idea/*" \
	    --exclude ".localized" \
	    --exclude ".local" \
	    --exclude ".sass-cache/*" \
	    --exclude "log/*.log" \
	    --exclude "tmp/*" \
	    --exclude ".bundle/*" \
	    --exclude "#*#" \
	    --exclude ".#*" \
	    --exclude ".Trashes/*" \
	    --exclude "node_modules/*" \
	    --exclude "bower_components/*" \
	    --exclude "*~" \
	    --exclude "*_flymake.*"


