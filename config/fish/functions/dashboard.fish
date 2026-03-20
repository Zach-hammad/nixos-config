function dashboard --description "Open ASCII system dashboard on workspace 9"
    if set -q ZELLIJ
        zellij action new-tab --layout dashboard --name "dashboard"
    else
        zellij --layout dashboard --session dashboard
    end
end
