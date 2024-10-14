#!/usr/bin/zsh
#
# This script will be run as a service, monitoring for any newly created
# asciinema cast file in all users' Documents/asciicasts directory. Newly
# created asciinema cast file will be flagged tobe append only.

fswatch -0 -l 3 --event Created \
    $(find /home/*/Documents/ -maxdepth 1 -type d -name asciicasts) | \
    xargs -0 -I {} /usr/local/bin/flagAsAppendOnly.zsh {}
