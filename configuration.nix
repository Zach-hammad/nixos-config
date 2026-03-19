{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "i915.enable_guc=3" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Filesystem — btrfs options
  fileSystems."/" = {
    options = [ "compress=zstd" "space_cache=v2" ];
  };
  fileSystems."/home" = {
    options = [ "compress=zstd" "space_cache=v2" ];
  };
  fileSystems."/nix" = {
    options = [ "compress=zstd" "noatime" "space_cache=v2" ];
  };
  fileSystems."/var/log" = {
    options = [ "compress=zstd" "space_cache=v2" ];
  };
  fileSystems."/.snapshots" = {
    options = [ "compress=zstd" "space_cache=v2" ];
  };

  # Networking
  networking.hostName = "precision";
  networking.networkmanager.enable = true;

  # Locale / Time
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Intel Arc GPU
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };
  environment.variables.LIBVA_DRIVER_NAME = "iHD";

  # Audio — PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Power management — TLP
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  services.power-profiles-daemon.enable = false;

  # GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Snapper — btrfs snapshots
  services.snapper = {
    snapshotInterval = "hourly";
    configs.root = {
      SUBVOLUME = "/";
      ALLOW_USERS = [ "zach" ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 10;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 4;
      TIMELINE_LIMIT_MONTHLY = 6;
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # User
  users.users.zach = {
    isNormalUser = true;
    description = "Zach";
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # Remove GNOME bloat
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-music
    gnome-tour
    gnome-contacts
    gnome-maps
    totem
    yelp
    cheese
    simple-scan
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # Terminal
    kitty

    # CLI tools
    git
    gh
    curl
    wget
    unzip
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    htop
    btop
    neovim

    # GNOME extras
    gnome-tweaks
    gnome-extension-manager
    wl-clipboard
    grim
    slurp
    brightnessctl

    # Filesystem / btrfs
    btrfs-progs
    snapper

    # System
    libnotify
    vulkan-tools
    libva-utils
    glxinfo

    # Fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    inter
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [ "Inter" ];
    serif = [ "Noto Serif" ];
    emoji = [ "Noto Color Emoji" ];
  };

  system.stateVersion = "25.05";
}
