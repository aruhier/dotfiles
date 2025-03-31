function _myaliases
    alias -s e='exit'
    alias -s d='devour'
    alias -s g='git'
    alias -s l='ls'
    alias -s mtrg='mtr 8.8.8.8'
    alias -s mtrg6='mtr 2001:4860:4860::8888'
    alias -s n='newterm'
    alias -s o='xdg-open'
    alias -s p='ping'
    alias -s pg='ping 8.8.8.8'
    alias -s pg6='ping 2001:4860:4860::8888'

    alias -s backup='sudo /root/.borg/backup.sh'
    alias -s cp='cp -r --reflink=auto'
    alias -s free='free -h'
    alias -s gitlog='git log --color'
    alias -s grep='grep --color'
    alias -s hibernate='systemctl hibernate'
    alias -s ll='ls -alh'
    alias -s ls='ls --color=auto'
    alias -s makepkgless='makepkg --config /etc/makepkg_less.conf'
    # If changed, change also the abbr.
    alias -s maj='yay'
    alias -s mkcd='mkdir_cd '
    alias -s mtr='mtr -o "LSR NABWV"'
    # alias -s private=' unset HISTFILE; _zoxide_hook(){}'
    alias -s reptyr='reptyr_authorization ' # Set the kernel to authorize ptracing
    alias -s sshnocheck='ssh -o StrictHostKeyChecking=no '
    alias -s sudo='sudo ' # Make aliases work with sudo

    # Firefox
    alias -s firefox='firefox-beta '
    alias -s firefox-aurora='firefox-aurora -p beta -no-remote'
    alias -s firefox-clean='firefox -p clean -no-remote'
end
