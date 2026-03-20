#!/usr/bin/env bash
# Symlink all configs from this repo to their expected locations
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"

# NixOS
sudo cp "$REPO/configuration.nix" /etc/nixos/configuration.nix
sudo cp "$REPO/flake.nix" /etc/nixos/flake.nix
sudo cp "$REPO/hardware-configuration.nix" /etc/nixos/hardware-configuration.nix

# User configs
ln -sfn "$REPO/config/hypr" ~/.config/hypr
ln -sfn "$REPO/config/alacritty" ~/.config/alacritty
ln -sfn "$REPO/config/waybar" ~/.config/waybar
ln -sfn "$REPO/config/zellij" ~/.config/zellij
ln -sfn "$REPO/config/helix" ~/.config/helix
ln -sfn "$REPO/config/wofi" ~/.config/wofi
ln -sfn "$REPO/config/mako" ~/.config/mako
ln -sfn "$REPO/config/wlogout" ~/.config/wlogout
ln -sfn "$REPO/config/gtk-3.0" ~/.config/gtk-3.0
ln -sfn "$REPO/config/gtk-4.0" ~/.config/gtk-4.0
cp "$REPO/config/fish/config.fish" ~/.config/fish/config.fish
cp "$REPO/config/fish/functions/"*.fish ~/.config/fish/functions/
cp "$REPO/config/starship/starship.toml" ~/.config/starship.toml

echo "done — run 'sudo nixos-rebuild switch --flake /etc/nixos#zwork' to apply"
