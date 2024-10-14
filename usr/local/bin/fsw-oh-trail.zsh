#!/bin/zsh
#
# This script designed to be run as a service and will be monitored by the git-oh-trail.zsh
# script which also runs as a service that monitoring if there's updated event on the /.gitignore
# file, then it will restart this service -- so that this service will re-read the content of
# the /.gitignore file.

fswatch -0 -o -l 3 --event Updated \
    $(cat /.gitignore|\
    sed 's/^!/\//;/[\*\/]\s*$/d;/^#.*\s*$/d;/^\s*$/d'\
    ) 2> /dev/null | \
    xargs -0 -n 1 /usr/local/bin/gitAutoCommit.zsh
