function backup --wraps='sudo /root/.borg/backup.sh' --description 'alias backup=sudo /root/.borg/backup.sh'
  sudo /root/.borg/backup.sh $argv
        
end
