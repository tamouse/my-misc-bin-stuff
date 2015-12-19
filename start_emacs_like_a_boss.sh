#!/bin/sh

echo "Starting Emacs like a boss"

/usr/local/Cellar/emacs/24.4/Emacs.app/Contents/MacOS/Emacs &

sleep 2
ps auxww | grep -v grep | grep -i --color=auto -E "(^USER|emacs)"
sleep 5
