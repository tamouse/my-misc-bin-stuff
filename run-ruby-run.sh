#!/bin/bash

## Run, Ruby, Run sets up the chruby environment for non-interactive scripts and, most especially, cron
source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.0.0
"$@"
