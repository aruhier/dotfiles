function makepkgless --wraps='makepkg --config /etc/makepkg_less.conf' --description 'alias makepkgless=makepkg --config /etc/makepkg_less.conf'
  makepkg --config /etc/makepkg_less.conf $argv
        
end
