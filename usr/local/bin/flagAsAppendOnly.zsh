#!/usr/bin/zsh
#
# This script is called by the castWatcher.zsh script.

echo "$(date) - Flagging '$1' as append only." >> /var/log/oh-trail.log
chattr +a "$1"
