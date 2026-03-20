if status is-interactive
    # Auto-start zellij if not already inside one
    if not set -q ZELLIJ
        zellij attach --create main
    end

    # SSH terminfo fallback
    alias ssh="TERM=xterm-256color command ssh"

    # Rust CLI aliases
    alias ls="eza"
    alias ll="eza -la"
    alias lt="eza --tree --level=2"
    alias cat="bat --plain"
    alias find="fd"
    alias grep="rg"
    alias sed="sd"
    alias du="dust"
    alias top="btm"
    alias diff="difft"

    # Git shortcuts
    alias gs="git status"
    alias gd="git diff"
    alias gl="git log --oneline -20"
    alias gp="git push"
    alias gc="git commit"
    alias ga="git add"
end
