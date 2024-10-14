# oh-trail

A Linux interactive SSH session audit-trail using multiplexer, asciinema, and
git version control.

# Main Features

1. Automatically record an interactive login shell in tmux multiplexer using
   asciinema and flag the asciinema cast file as append only.
2. Auto git add, commit and push changes made on configuration files configured
   tobe tracked.

# Dependencies

* asciinema
* fswatch
* git
* gpg
* tmux
* zsh
* startship

# Step-by-step Configuration

These are the configuration steps right after a fresh installation of a Linux
headless server and done while switches to the `root` account.

1. Switch to the root account:
   ```shell
   sudo -i
   ```
2. Assuming git, gpg, & ZSH have already pre-installed on the machine. Install
   fswatch, asciinema, tmux, & starship:
    ```shell
    curl -sS https://starship.rs/install.sh | sh
    apt install asciinema tmux fswatch
    ```
3. Make Documents directory and clone the oh-trail repository into it:
   ```shell
   mkdir Documents
   git clone https://github.com/VimfanTPdvorak/oh-trail.git
   ```
4. Configure the default shell, allowed shell and newly created user home
   directory structures:
    1. Change the default shell for newly created user to /usr/bin/zsh.
       Configure that within the /etc/default/useradd configuration file:
       ```config
       SHELL=/usr/bin/zsh
       ```
    2. Configure the allowed shells within the /etc/shells to only these:
       ```config
       /usr/bin/tmux
       /usr/bin/zsh
       ```
    3. Remove all files within the /etc/skel directory, then copy all of the
       files from ~/Documents/oh-trail/etc/skel into it.
       ```shell
       rm /etc/skel/*.*
       cp -r ~/Documents/oh-trail/etc/skel/*.* /etc/skel/
       ```
5. Oh-trail configurations:
    1. Copy needed services & scripts files:
       ```shell
       mkdir ~/bin
       cp ~/Documents/oh-trail/etc/systemd/system/* /etc/systemd/system/
       cp ~/Documents/oh-trail/root/bin/gpg-preset.zsh ~/bin/
       cp ~/Documents/oh-trail/usr/local/bin/* /usr/local/bin/
       cp ~/Documents/oh-trail/etc/zsh/* /etc/zsh/
       mkdir /usr/share/oh-trail
       cp ~/Documents/oh-trail/usr/share/oh-trail/* /usr/share/oh-trail/
       ```
    2. Update the sudoers configuration. Edit it using the `visudo` command,
       remove all its content and load it from the standardized sudoers
       configuration file ~/Documents/oh-trail/etc/sudoers.
    3. Create GPG public private keypair:
       1. Prepare its strong passphrase:
          ```shell
          apt install apg
          mkdir -p ~/.config
          apg -M SNCL -m 12|tr -d '\n' > ~/.config/.secret
          chmod 400 ~/.config/.secret
          ```
       2. Open the ~/.config/.secret file and copy its content (the passphrase)
          to the clipboard tobe later pasted into the prompted passphrase during
          public private key generation process.
       3. Run the generate public private key command:
          ```shell
          gpg --full-generate-key
          ```
           1. Set the name the same as the above given GIT user.name
           2. Set the email also the same as the above assigned GIT user.email
           3. Set its to never expire
           4. Paste the passphrase into enter passphrase & re-enter passphrase
              prompt
       4. Copy needed gpg-agent config file:
          ```shell
          copy ~/Documents/oh-trail/root/.gnupg/gpg-agent.conf ~/.gnupg/
          ```
       5. Activate the gpg-preset timer:
          ```shell
          systemctl daemon-reload
          systemctl enable --now gpg-preset.timer
          ```
    4. Create a self-hosted git server repository that will be used to host the
       locally auto-committed configuration changes:
       1. Create GPG encrypted netrc configuration file that store the git
          remote credentials:
          1. Create a strong password:
             ```shell
             apg -M SNCL -m 12|head -3|tr -d '\n'|sed 's/\\/\\\\/g' > /tmp/t.txt
             ```
          2. Edit the /tmp/t.txt file to become something like this:
             ```netrc
             machine your.self-hosted.git.com
              login snail
              password thisIsTheStrongPasswordGeneratedFromThePreviousStep
              protocol https
             ```
          3. Encrypt the file into ~/.netrc.gpg then shred the /tmp/t.txt file:
             ```shell
             gpg -eao ~/.netrc.gpg /tmp/t.txt -r snail
             shred --remove=wipesync /tmp/t.txt
             ```
       2. Create a new account with the name of the server hostname. i.e: snail,
          and email address root@snail.server_fqdn, i.e:
          root@snail.your-server.com.
       3. Use the password recorded in the above ~/.netrc.gpg
    5. Create git repository on root `/`, the initial `.gitignore`
       configuration file, and setting up some GIT configuration:
       ```shell
       cd /
       git init
       cp ~/Documents/oh-trail/gitignore .gitignore
       git config --global user.name "{server_host_name}"
       git config --global user.email "{root@server_fqdn}"
       git config --global credential.helper "netrc -f ~/.netrc.gpg -v"
       ```
       Change the server_host_name to server's hostname, i.e: snail, and
       server_fqdn to server FQDN, i.e: snail.your-server.com.
    6. Create an initial commit and push to the server:
       ```shell
       git add .
       git commit -m "Initial commit."
       git remote add origin https://your.self-hosted.git.com/Your.Account/snail.git
       git push -u origin master
       ```
       Change the `Your.Account` ande `snail` to the appropriate names.
    7. Start oh-trail services.
       ```shell
       systemctl start fsw-oh-trail.service
       systemctl start git-oh-trail.service
       systemctl start castWatcher.service
       systemctl start newUserWatcher.service
       ```
    8. Check if all above service have been started succesfully.
       ```shell
       systemctl status fsw-oh-trail.service
       systemctl status git-oh-trail.service
       systemctl status castWatcher.service
       systemctl status newUserWatcher.service
       ```

# TODO

* [X] Prompt the user to enter the reason for accessing the server once they
      have logged into the interactive SSH session.
* [X] Generate a cast.log file that logs a summary of the SSH session.
* [ ] Move the asciinema cast file to a designated server once the recording has
      finished.
