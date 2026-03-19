{ config, pkgs, lib, ... }:

{
  home.username = "zach";
  home.homeDirectory = "/home/zach";
  home.stateVersion = "25.05";

  # ── Rust (via rust-overlay) ──────────────────────────────────────────
  home.packages = with pkgs; [
    # Rust — stable + nightly
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    })
    rust-bin.nightly.latest.default
    cargo-watch
    cargo-edit
    cargo-expand

    # Python + ML
    (python312.withPackages (ps: with ps; [
      torch-bin
      torchvision-bin
      numpy
      pandas
      scipy
      scikit-learn
      matplotlib
      jupyter
      ipython
      pip
      virtualenv
    ]))

    # Node
    nodejs_22
    nodePackages.pnpm
    bun

    # Dev tools
    lazygit
    delta
    zoxide
    starship
    direnv
    nix-direnv
    gcc
    gnumake
    pkg-config
    openssl

    # Apps
    firefox
    obsidian
    zathura
    imv
    mpv
    discord
    spotify

    # GNOME extensions
    gnomeExtensions.forge
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
  ];

  # ── GNOME / dconf settings ──────────────────────────────────────────
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      monospace-font-name = "JetBrainsMono Nerd Font 13";
      font-name = "Inter 11";
      document-font-name = "Inter 11";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4;
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      close = [ "<Super>q" ];
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "forge@jmmaranan.com"
        "blur-my-shell@aunetx"
        "appindicatorsupport@rgcjonas.gmail.com"
        "clipboard-indicator@tudmotu.com"
        "caffeine@pataber.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "obsidian.desktop"
        "discord.desktop"
        "spotify.desktop"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "kitty";
      binding = "<Super>Return";
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      edge-tiling = true;
      workspaces-only-on-primary = true;
    };
    # Touchpad
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
      natural-scroll = true;
    };
  };

  # ── Git ──────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName = "Zach";
    userEmail = "zach@scoutautos.com";
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Catppuccin Mocha";
      };
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      merge.conflictstyle = "zdiff3";
      rerere.enabled = true;
    };
  };

  # ── Zsh ──────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      share = true;
    };
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -la --icons";
      lt = "eza --tree --icons";
      cat = "bat";
      g = "git";
      lg = "lazygit";
      v = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake /home/zach/nixos-config#precision";
    };
    initContent = ''
      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
    '';
  };

  # ── Starship prompt ──────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$rust"
        "$python"
        "$nodejs"
        "$nix_shell"
        "$character"
      ];
      directory.style = "bold blue";
      git_branch.style = "bold mauve";
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };
    };
  };

  # ── Kitty ────────────────────────────────────────────────────────────
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };
    settings = {
      # Catppuccin Mocha
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      url_color = "#F5E0DC";

      color0 = "#45475A";
      color8 = "#585B70";
      color1 = "#F38BA8";
      color9 = "#F38BA8";
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";
      color4 = "#89B4FA";
      color12 = "#89B4FA";
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";
      color6 = "#94E2D5";
      color14 = "#94E2D5";
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";

      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      background_opacity = "0.95";
    };
  };

  # ── GTK — Catppuccin Mocha ───────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-blue-standard+default";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        accent = "blue";
        flavor = "mocha";
      };
    };
    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
  };

  # ── Direnv ───────────────────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
