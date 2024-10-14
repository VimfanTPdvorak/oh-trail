#!/usr/bin/zsh
#
# Load GPG passphrase into cache.

/usr/lib/gnupg/gpg-preset-passphrase --preset \
    $(gpg --with-keygrip -K|tail -2|head -1|awk '{print $3}') \
    < ~/.config/.secret
