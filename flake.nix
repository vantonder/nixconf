{
  description = "My nix-based configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  

    nur.url = "github:nix-community/nur";
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let 
      overlays = [
        inputs.nur.overlay
      ];

      mkSystem = import ./lib/mksystem.nix { inherit inputs nixpkgs overlays; };
    in {
      nixosConfigurations = {
        titan = mkSystem "titan" {
          system = "x86_64-linux";
        };
      };
    };
}
