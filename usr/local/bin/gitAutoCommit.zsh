#!/bin/zsh

sleepTime=0
maxSleepTime=30

echo "$(date) - Tracked files updated event triggerred." >> /var/log/oh-trail.log

if [[ -z $(git status|grep -o '^nothing to commit, working tree clean') ]];then
    while [[ -f /.git/index.lock ]] && [[ $sleepTime -lt $maxSleepTime ]]; do
        echo "$(date) - Waiting for another git process to finish its job." \
            >> /var/log/oh-trail.log
        sleep 1
        sleepTime=$((sleepTime + 1))
    done

    if [[ -z $(git status|grep -o '^nothing to commit, working tree clean') ]];then
        if [[ -f /.git/index.lock ]];then
            echo "$(date) - Giving up waiting for another git process to complete." \
                >> /var/log/oh-trail.log
        else
            git add /. > /dev/null 2>&1

            echo "$(date) - Auto-commit changes on monitored files." >> \
                /var/log/oh-trail.log

            git commit -a -m "Auto-commit changes on monitored files." \
                > /dev/null 2>> /var/log/oh-trail.log
            git push
        fi
    fi
fi
