function backup --wraps='sudo /root/.backups/backup.sh' --description 'alias backup=sudo /root/.backups/backup.sh'
  sudo /root/.backups/backup.sh $argv

end
