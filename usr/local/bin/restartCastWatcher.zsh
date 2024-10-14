#!/usr/bin/zsh
#
# Restart castWatcher.service on the event of /etc/passwd updated event.

debounce_time=1  # seconds

if [[ -f /tmp/restartCastWatcher.last_event_time ]];then
    last_event_time=$(cat /tmp/restartCastWatcher.last_event_time)
else
    last_event_time=0
fi

local event_time=$(date +%s)  # Get current time in seconds

if (( event_time - last_event_time > debounce_time )); then
    echo "$(date) - Restarting castWatcher.service" >> /var/log/oh-trail.log
    systemctl restart castWatcher.service
    last_event_time=$event_time
    echo $last_event_time > /tmp/restartCastWatcher.last_event_time
fi
