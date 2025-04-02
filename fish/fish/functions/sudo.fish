function sudo --wraps='sudo'
    set -l options
    set -l args

    # Separate options (starting with -) from the rest
    for arg in $argv
        if string match -qr '^-' -- $arg
            set options $options $arg
        else
            set args $args $arg
        end
    end

    set -l func (functions --no-details $args[1])
    # If the first non-option argument is an alias.
    if string match -q "*--description 'alias *" -- $func[1]
        # Read the function definition and get the first non-comment line
        set -l alias_content (echo $func[2..] | sed -E 's/\s*(command)?\s*(.*)\s+\$argv\s*(end)?/\2/')
        set -e args[1]
        set args (string split ' ' $alias_content) $args
    end

    command sudo $options $args
end
