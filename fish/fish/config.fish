if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting

    if not infocmp -U $TERM &>/dev/null
        set -gx TERM xterm-256color
    end

    if type -q nvim
        set -x EDITOR nvim
        set -x DIFFPROG "nvim -d"
    else
        set -x EDITOR vim
    end
    set -x GIT_EDITOR $EDITOR

    if not set -q SSH_CONNECTION
        set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    end

    # A dummy wait of 5ms. Without it, the terminal might get resized and the prompt get printed on multiple time.
    sleep 0.01
end
