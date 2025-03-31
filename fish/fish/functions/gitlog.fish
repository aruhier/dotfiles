function gitlog --wraps='git log --color' --description 'alias gitlog=git log --color'
  git log --color $argv
        
end
