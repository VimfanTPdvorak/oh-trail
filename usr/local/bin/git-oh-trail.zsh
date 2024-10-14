#!/bin/zsh
#
# This script designed to be run as a service that related to the fsw-oh-trail.zsh service.
# Read the comment on that script for more information.

fswatch -0 -o -l 2 --event Updated /.gitignore 2> /dev/null | \
    xargs -0 -n 1 /usr/local/bin/restartFsw-oh-trail.zsh
