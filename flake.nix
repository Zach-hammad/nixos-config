{
  description = "zwork NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, fenix, ... }: {
    nixosConfigurations.zwork = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit fenix; };
      modules = [ ./configuration.nix ];
    };
  };
}
