status is-interactive
or exit 0

bind -M insert \e\[3\;5~ kill-word              # Ctrl+Delete

bind -M insert \cr history-search-backward      # Ctrl+R
bind -M insert \cs history-search-forward       # Ctrl+S

bind -M insert jk 'set fish_bind_mode default; commandline -f repaint'
