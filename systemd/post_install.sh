#!/bin/bash

enable_user_services() {
    systemctl --user enable --now hypridle
    systemctl --user enable --now kanshi
    systemctl --user enable --now kdeconnectd
    systemctl --user enable --now lxqt-policykit-agent
    systemctl --user enable --now quickshell
}

# Cleanup broken links.
find ~/.config/systemd/user -xtype l -lname "$HOME/dotfiles/*" -delete

systemctl --user daemon-reload
enable_user_services
