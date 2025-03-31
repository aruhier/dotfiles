status is-interactive
or exit 0

if test -f ~/.fzf.zsh
    source ~/.fzf.fish
else if test -f /usr/share/fzf/key-bindings.fish
    source /usr/share/fzf/key-bindings.fish
else if test -f /usr/share/fzf/shell/key-bindings.fish
    source /usr/share/fzf/shell/key-bindings.fish
else if test -f /usr/share/doc/fzf/examples/key-bindings.fish
    source /usr/share/doc/fzf/examples/key-bindings.fish
end

if functions -q fzf_key_bindings
    fzf_key_bindings
end
