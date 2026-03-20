function fish_greeting
    set_color brblack
    echo '                                                    '
    echo '  ┌──────────────────────────────────────────────┐  '
    echo '  │                                              │  '
    set_color white
    echo -n '  │  '
    set_color brwhite
    echo -n '> initializing zwork...'
    set_color brblack
    echo '                   │  '
    set_color white
    echo -n '  │  '
    set_color brwhite
    echo -n '> shell: fish '
    set_color brblack
    echo -n (fish --version 2>/dev/null | string replace 'fish, version ' '')
    echo '                  │  '
    set_color white
    echo -n '  │  '
    set_color brwhite
    echo -n '> rust: '
    set_color brblack
    echo -n (rustc --version 2>/dev/null | string replace 'rustc ' '' | string split ' ' | head -1)
    echo '                      │  '
    set_color white
    echo -n '  │  '
    set_color brwhite
    echo -n '> kernel: '
    set_color brblack
    echo -n (uname -r | string split '-' | head -1)
    echo '                       │  '
    set_color white
    echo -n '  │  '
    set_color brwhite
    echo -n '> uptime: '
    set_color brblack
    echo -n (uptime -p 2>/dev/null | string replace 'up ' '')
    echo '              │  '
    set_color white
    echo -n '  │  '
    set_color brwhite
    echo -n '> palette: #000 #FFF '
    set_color brblack
    echo '[MONOCHROME]        │  '
    set_color white
    echo -n '  │  '
    set_color brwhite
    echo -n '> status: '
    set_color white
    echo -n 'OPERATIONAL'
    set_color brblack
    echo '                    │  '
    echo -n '  │  '
    set_color brwhite
    echo -n '> _'
    set_color white
    echo -n '█'
    set_color brblack
    echo '                                          │  '
    echo '  │                                              │  '
    echo '  └──────────────────────────────────────────────┘  '
    echo '                                                    '
    set_color normal
end
