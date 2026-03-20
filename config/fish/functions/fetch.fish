function fetch --description "Monochrome system fetch"
    set -l host (hostname)
    set -l user (whoami)
    set -l os "NixOS"
    set -l kernel (uname -r | string split '-' | head -1)
    set -l shell "fish"
    set -l uptime_str (uptime -p 2>/dev/null | string replace 'up ' '')
    set -l cpu (cat /proc/cpuinfo 2>/dev/null | grep 'model name' | head -1 | string replace -r '.*: ' '')
    set -l mem_total (math (cat /proc/meminfo | grep MemTotal | string replace -r '[^0-9]' '') / 1024 / 1024)
    set -l mem_used (math (cat /proc/meminfo | grep 'MemTotal|MemAvailable' | head -2 | awk 'NR==1{t=$2} NR==2{print t-$2}') / 1024 / 1024 2>/dev/null)
    set -l pkgs (nix-store --query --requisites /run/current-system 2>/dev/null | wc -l)
    set -l de "GNOME/Wayland"
    set -l term "alacritty + zellij"
    set -l editor "helix"

    set_color brblack
    echo ''
    echo '         ┌─────────────────────────────────────────────'
    set_color white
    echo -n '    ▄▄   '
    set_color brblack
    echo -n '│ '
    set_color brwhite
    echo $user@$host
    set_color white
    echo -n '   █▀▀█  '
    set_color brblack
    echo '│─────────────────────────────────────────'
    set_color white
    echo -n '   █  █  '
    set_color brblack
    echo -n '│ '
    set_color brwhite
    echo -n 'os     '
    set_color brblack
    echo $os
    set_color white
    echo -n '   █  █  '
    set_color brblack
    echo -n '│ '
    set_color brwhite
    echo -n 'kernel '
    set_color brblack
    echo $kernel
    set_color white
    echo -n '   █▄▄█  '
    set_color brblack
    echo -n '│ '
    set_color brwhite
    echo -n 'shell  '
    set_color brblack
    echo $shell
    set_color white
    echo -n '    ▀▀   '
    set_color brblack
    echo -n '│ '
    set_color brwhite
    echo -n 'de     '
    set_color brblack
    echo $de
    set_color white
    echo -n '   ▄  ▄  '
    set_color brblack
    echo -n '│ '
    set_color brwhite
    echo -n 'term   '
    set_color brblack
    echo $term
    set_color white
    echo -n '   █▀▀█  '
    set_color brblack
    echo -n '│ '
    set_color brwhite
    echo -n 'editor '
    set_color brblack
    echo $editor
    set_color white
    echo -n '   █  █  '
    set_color brblack
    echo -n '│ '
    set_color brwhite
    echo -n 'pkgs   '
    set_color brblack
    echo $pkgs "(nix)"
    set_color white
    echo -n '   ▀▀▀▀  '
    set_color brblack
    echo -n '│ '
    set_color brwhite
    echo -n 'uptime '
    set_color brblack
    echo $uptime_str
    set_color brblack
    echo '         │'
    echo -n '         │ '
    # Monochrome palette blocks
    set_color -b 000000
    echo -n '   '
    set_color -b 1a1a1a
    echo -n '   '
    set_color -b 404040
    echo -n '   '
    set_color -b 808080
    echo -n '   '
    set_color -b a0a0a0
    echo -n '   '
    set_color -b d4d4d4
    echo -n '   '
    set_color -b ffffff
    echo -n '   '
    set_color normal
    set_color brblack
    echo ''
    echo '         └─────────────────────────────────────────────'
    echo ''
    set_color normal
end
