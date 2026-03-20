# Open a repo in a new zellij tab with helix + bacon + claude
# Usage: dev scout/Scout
#        dev shared/vector-base
#        dev vision/vision-rs
function dev --description "Open a repo in a dev tab"
    set -l repo_path ""

    # Check ~/work/ first, then ~/personal/
    if test -d ~/work/$argv[1]
        set repo_path ~/work/$argv[1]
    else if test -d ~/personal/$argv[1]
        set repo_path ~/personal/$argv[1]
    else
        # Try searching for just the repo name in all subdirs
        set -l found (find ~/work ~/personal -maxdepth 2 -name "$argv[1]" -type d 2>/dev/null | head -1)
        if test -n "$found"
            set repo_path $found
        else
            echo "repo not found: $argv[1]"
            return 1
        end
    end

    set -l tab_name (basename $repo_path)

    if set -q ZELLIJ
        # Inside zellij — open new tab
        zellij action new-tab --layout repo --name "$tab_name" --cwd "$repo_path"
    else
        # Outside zellij — start a new session
        cd $repo_path
        zellij --layout repo --session "$tab_name"
    end
end
