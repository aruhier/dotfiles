function majsync --wraps='sudo emerge --sync; sudo eix-update' --description 'alias majsync=sudo emerge --sync; sudo eix-update'
  sudo emerge --sync; sudo eix-update $argv
        
end
