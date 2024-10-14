#!/bin/zsh

echo "$(date) - Restarting fsw-oh-trail.service" >> /var/log/oh-trail.log

systemctl restart fsw-oh-trail.service

sleep 2

. /usr/local/bin/gitAutoCommit.zsh
