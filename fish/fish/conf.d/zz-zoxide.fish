status is-interactive
or exit 0

if type -q zoxide
    set -x _ZO_FZF_OPTS "--height 40%"
    zoxide init fish | source

    bind -M insert \cF zoxide_query_widget
end
