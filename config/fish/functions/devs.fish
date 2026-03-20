# Open multiple repos at once
# Usage: devs scout/Scout shared/vector-base vision/vision-rs
function devs --description "Open multiple repos in dev tabs"
    for repo in $argv
        dev $repo
    end
end
