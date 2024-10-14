#!/bin/zsh
# This script was designed to be called from ~/.zshrc. This script will use
# asciinema to start recording a terminal session inside a tmux session.
#
# Currently we save the asciicast inside the ~/Documents/asciicasts folder. At
# later time we'll save it in an asciicast storage server once the server is up.

castPath=~/Documents/asciicasts

mkdir -p $castPath

if [[ -n "$TMUX" ]];then
    if [[ $(tmux ls|awk '{print $2}') -eq 1 ]] && [[ -f /usr/share/oh-trail/tmux.info ]];then
        cat /usr/share/oh-trail/tmux.info
    fi
else
    if [[ -f ~/.oh-trail ]];then
        lfname=$(cat ~/.oh-trail)
    else
        lfname=""
    fi

    userName=$(whoami)
    tmuxSession=$(tmux ls 2> /dev/null|grep "$userName")

    if [[ -z "${tmuxSession}" ]];then
        timeMarker=$(date)
        fname=$(echo "$castPath/$userName $timeMarker.cast"|sed 's/\ /_/g')
        sessionID=$(echo "$username $timeMarker"|sed 's/\ /_/g')

        # Record the last cast filename into the ~/.oh-trail to be used later in
        # case of a broken pipe SSH connection.
        echo -n "$fname" > ~/.oh-trail

        sessionID=$(basename $fname)
        sessionID="${sessionID%.*}"

        sudo oh-trail-log-cast.zsh "$(date) - $sessionID: Start"
        sudo oh-trail-log-cast.zsh "$(date) - $sessionID: Reason: "

        tmp_file=$(mktemp /tmp/oh-trail_commit_msg.XXXXXX)
        tmp_file_no_comment=$(mktemp /tmp/oh-trail_msg.XXXXXX)

        cat /usr/share/oh-trail/oh-trail.info > "$tmp_file"

        while [[ -f "$tmp_file" ]];do
            vim "$tmp_file"
            if [[ ! -z $(cat "$tmp_file" | sed "/^\s*#/d;/^\s*$/d") ]];then
                cat "$tmp_file"|sed "/^\s*#/d;s/^/$(date) - $sessionID: /" > "$tmp_file_no_comment"
                sudo oh-trail-log-cast.zsh -f "$tmp_file_no_comment"
                rm "$tmp_file" "$tmp_file_no_comment"
            fi
        done

        asciinema rec $fname -i 0.5 -c "tmux new -s $userName"
    else
        if [[ -z "$(ps -a|grep asciinema)" ]];then
            # If there's no active asciinema process, it meant that the last
            # tmux session was ended abnormally, i.e: broken pipe SSH session.
            asciinema rec $lfname -i 0.5 -c "tmux a" --append
        else
            # If there's an active asciinema process, it meant that the user
            # was still in the logged in SSH session but then SSH logged in
            # again from another terminal. In that case, we should simply
            # attact to the related tmux session.
            tmux a
        fi
    fi

    # The asciinema will stop the recording of a tmux session whenever the tmux
    # session ended or simply detacted.  Hence, we'll kill the tmux session
    # before exiting the user from the SSH logged in session in the case of the
    # asciinema recording ended due to user detacted from the tmux session,
    if [[ ! -z "$(tmux ls|grep $userName)" ]];then
        tmux kill-server
    fi

    sudo oh-trail-log-cast.zsh "$(date) - $sessionID: Done."

    exit
fi
