function clean_obsolete_pkg --wraps='portpeek -se' --description 'alias clean_obsolete_pkg=portpeek -se'
  portpeek -se $argv
        
end
