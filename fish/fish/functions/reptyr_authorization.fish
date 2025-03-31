function reptyr_authorization
    ORIG_VALUE=`cat /proc/sys/kernel/yama/ptrace_scope`
    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope > /dev/null
    reptyr $argv
    echo "$ORIG_VALUE" | sudo tee /proc/sys/kernel/yama/ptrace_scope > /dev/null
end
