# Edit functions/_myaliases.fish for the _myaliases function that generates all
# the aliases.

# Dynamic alias, cannot be saved in a file.
if type -q nvim
    alias v='nvim'
    alias vim='nvim'
else
    alias v='vim'
end

abbr -a majabbr 'systemd-run -t -p CPUWeight=20 -p CPUQuota=3000% --user -- sudo emerge -uDU --ask --keep-going --newrepo --with-bdeps=y -j 5 --load-average=20 @world && sudo emerge --depclean && sudo eclean-dist --deep
        echo; echo "Flatpak"; echo "======="; flatpak update; flatpak uninstall --unused'
