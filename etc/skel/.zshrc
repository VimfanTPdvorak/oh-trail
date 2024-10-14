export PATH=$HOME/tools/sh:$HOME/.local/kitty.app/bin:$PATH
PATH=$HOME/bin:$HOME/tools/zsh:$HOME/.local/bin:$PATH
PATH=$PATH:$HOME/.cargo/bin:$HOME/.cargo/bin/zellij

export EDITOR=vim

# Make any command starts with a space will not be recorded in the shell
# command history.
export HISTIGNORE="&: "

# Commands that start with a space character will not be saved to the command
# history
setopt HIST_IGNORE_SPACE

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Enable vi style line editing
set -o vi

# This is to prevent the prompt configured using startship to act wierd
export LC_CTYPE=en_US.UTF-8

# Bind v in vi style editing to launch VIM
bindkey -M vicmd v edit-command-line

alias misell="zsh -c \"xdosemu /mnt/x/APLIKASI/BIAYA/BIAYA.BAT &\""
alias calc="zsh -c \"libreoffice --calc\""
alias writer="zsh -c \"libreoffice --writer\""
alias xclip="xclip -selection c"

#PS1='%F{yellow}%n%f%F{blue}@%f%F{green}%M%f%~ %F{magenta}%D{%a %Y/%m/%d %H:%M}%f
#❯ '

eval "$(starship init zsh)"
