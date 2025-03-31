# mkdir_cd - mkdir and cd in the directory
# $argv[1] - target directory
function mkdir_cd
    mkdir $argv && cd $argv
end
complete -c mkdir_cd -a "(__fish_complete_directories)" -f -d 'Target directory'
