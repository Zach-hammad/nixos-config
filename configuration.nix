{ config, pkgs, fenix, ags, ... }:

let
  rust-toolchain = fenix.packages.${pkgs.system}.stable.withComponents [
    "cargo" "clippy" "rust-src" "rustc" "rustfmt"
  ];
  rust-analyzer = fenix.packages.${pkgs.system}.rust-analyzer;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Flakes & store maintenance
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "zwork";
  networking.networkmanager.enable = true;

  # Time & locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  # Desktop: Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  hardware.graphics.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Cursor theme
  environment.sessionVariables.XCURSOR_THEME = "Bibata-Modern-Classic";
  environment.sessionVariables.XCURSOR_SIZE = "24";

  # Printing
  services.printing.enable = true;

  # Sound: PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Firewall
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Fish shell
  programs.fish.enable = true;

  # Direnv + nix-direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Firefox
  programs.firefox.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];
  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
      enable = true;
      style = "slight";
    };
    subpixel.rgba = "none";
  };

  # User
  users.users.zach = {
    isNormalUser = true;
    description = "Zacharia Hammad";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Rust toolchain (via fenix)
    rust-toolchain
    rust-analyzer

    # Editor
    helix

    # Terminal & multiplexer
    alacritty
    zellij

    # File manager
    xfce.thunar
    xfce.thunar-volman
    xfce.tumbler

    # Cursor theme
    bibata-cursors

    # Hyprland ecosystem
    waybar
    wofi
    mako
    hyprlock
    hypridle
    mpvpaper
    wl-clipboard
    cliphist
    grim
    slurp
    hyprpolkitagent
    networkmanagerapplet
    brightnessctl
    # AGS (volume OSD + mixer)
    ags.packages.${pkgs.system}.default
    adw-gtk3

    # Cargo extensions
    bacon
    cargo-watch
    cargo-edit
    cargo-expand
    cargo-flamegraph
    cargo-deny
    cargo-audit
    cargo-nextest
    cargo-tarpaulin
    cargo-bloat
    cargo-outdated
    cargo-msrv
    cargo-insta
    cargo-make

    # Build acceleration
    sccache
    mold
    clang
    pkg-config

    # Rust CLI tools
    ripgrep
    fd
    bat
    eza
    zoxide
    starship
    tokei
    dust
    bottom
    delta
    sd
    hyperfine
    difftastic
    fzf
    yazi
    jq

    # Git tools
    git
    gh
    gitui
    lazygit

    # Debugging
    lldb
    gdb

    # ML/AI essentials
    python3
    python3Packages.pip
    python3Packages.virtualenv

    # Build deps
    openssl
    openssl.dev

    # ASCII art & fun
    cmatrix
    pipes-rs
    cbonsai

    # General
    wget
    curl
    unzip
    file
  ];

  # Environment variables for Rust builds
  environment.variables = {
    RUST_SRC_PATH = "${rust-toolchain}/lib/rustlib/src/rust/library";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  # Starship prompt for fish
  programs.fish.interactiveShellInit = ''
    starship init fish | source
    zoxide init fish | source
  '';

  system.stateVersion = "25.11";
}
