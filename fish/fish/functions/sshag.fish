function sshag --description 'Start an ssh-agent for 1h'
    [[ "$SSH_AGENT_PID" ]] || eval $(ssh-agent -t 3600);
    ssh-add ~/.ssh/id_rsa
end

