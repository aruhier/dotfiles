function sshnocheck --wraps='ssh -o StrictHostKeyChecking=no ' --description 'alias sshnocheck=ssh -o StrictHostKeyChecking=no '
  ssh -o StrictHostKeyChecking=no  $argv
        
end
