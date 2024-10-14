#!/bin/zsh
#
# This script designed to be run as a service that watch the /etc/passwd file
# for changes. If updated event triggered, it will restart the castWatcher
# service.

# Monitor /etc/passwd for any update event
fswatch -0 -o -l 2 --event Updated /etc/passwd 2> /dev/null | \
    xargs -0 -n 1 /usr/local/bin/restartCastWatcher.zsh
