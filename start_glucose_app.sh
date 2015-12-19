#!/bin/sh 
cd $HOME/Library/WebServer/glucose
export RAILS_ENV=production
export SECRET_KEY_BASE=`bin/rake secret`
/usr/bin/bundle exec unicorn --config-file config/unicorn.rb --daemonize
