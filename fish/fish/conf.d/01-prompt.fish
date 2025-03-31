function fish_default_mode_prompt --description 'Display vi prompt mode'
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" = fish_vi_key_bindings
        or test "$fish_key_bindings" = fish_hybrid_key_bindings
        # Only prints something in non insert mode.
        switch $fish_bind_mode
            case default
                set_color --bold red
                echo '[N]'
            case insert
                return
            case replace_one
                set_color --bold green
                echo '[R]'
            case replace
                set_color --bold cyan
                echo '[R]'
            case visual
                set_color --bold magenta
                echo '[V]'
        end
        set_color normal
        echo -n ' '
    end
end

function prompt_login --description 'display user name for the prompt'
    if functions -q fish_is_root_user; and fish_is_root_user
        set color_user $fish_color_user_root
    else
        set color_user $fish_color_user
    end

    if not set -q __fish_machine
        set -g __fish_machine
        set -l debian_chroot $debian_chroot

        if test -r /etc/debian_chroot
            set debian_chroot (cat /etc/debian_chroot)
        end

        if set -q debian_chroot[1]
            and test -n "$debian_chroot"
            set -g __fish_machine "(chroot:$debian_chroot)"
        end
    end

    # Prepend the chroot environment if present
    if set -q __fish_machine[1]
        echo -n -s (set_color yellow) "$__fish_machine" (set_color normal) ' '
    end

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY; and set -q fish_color_host_remote
        set color_host $fish_color_host_remote
    end

    echo -n -s (set_color $color_user) "$USER" (set_color $color_host) @ (set_color -u $color_host) (prompt_hostname) (set_color normal)
end

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)
    set -q fish_color_status
    or set -g fish_color_status red

    set -l suffix '>'

    # Write pipestatus
    # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY; and set -q fish_color_host_remote
        set color_host $fish_color_host_remote
    end

    echo -n -s $prompt_status" " (prompt_login) (set_color $color_host) $suffix " " (set_color normal)
end

function fish_right_prompt --description 'Write out the right side prompt'
    set -l normal (set_color normal)
    set -l color_cwd $fish_color_cwd
    set -l empty_char (echo -e \u200B)
    set -l vcs_char (echo -e \uE0A0)
    set -l vcs_prompt (echo -e "\e[3m"(fish_vcs_prompt)"  \e[0m")

    echo -n -s (set_color 909090) $vcs_prompt (set_color $color_cwd) (prompt_pwd -d 0)" " (set_color normal)
end

# Async configuration.
set -U async_prompt_functions fish_vcs_prompt
