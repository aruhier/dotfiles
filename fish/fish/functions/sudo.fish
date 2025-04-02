function sudo --wraps='sudo'
    set -l options

    # Separate options (starting with -) from the rest
    for arg in $argv
        if string match -qr '^-' -- $arg
            set options $options $arg
            set -e argv[1]
        else
            break
        end
    end

    set -l func (functions --no-details $argv[1])
    # If the first non-option argument is an alias.
    if string match -q "*--description 'alias *" -- $func[1]
        # Read the function definition and get the first non-comment line
        set -l alias_content (echo $func[2..] | sed -E 's/\s*(command)?\s*(.*)\s+\$argv\s*(end)?/\2/')
        set -e argv[1]
        set argv (string split ' ' $alias_content) $argv
    end

    command sudo $options $argv
end
