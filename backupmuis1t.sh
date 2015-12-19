#!/bin/sh 

START_PATH=/Volumes/muis1t/
END_PATH=/Volumes/sg2t/backups/muis1t/
EXCLUDES_PATH=/Volumes/muis1t/rsync-excludes
RSYNC=`which rsync`
RSYNC_OPTS='-avz --progress'

if [ -d $END_PATH ]; then
    $RSYNC $RSYNC_OPTS --exclude=backups --exclude-from=$EXCLUDES_PATH $START_PATH $END_PATH
else
    echo "Backup $END_PATH is not mounted!"
    exit -1
fi

