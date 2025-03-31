function clean_cache
    sync
    su -c "echo 3 > /proc/sys/vm/drop_caches"
end
