{
  description = "zwork NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags/v1";
    };
  };

  outputs = { self, nixpkgs, fenix, ags, ... }: {
    nixosConfigurations.zwork = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit fenix ags; };
      modules = [ ./configuration.nix ];
    };
  };
}
