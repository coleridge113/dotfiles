function ssh_jerry() {
    ssh root@72.60.236.111
}

function eam_deploy() {
    cd ~/dev/eamcb/eam-web && npm run deploy:embed
}

