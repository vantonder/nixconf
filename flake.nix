{
  description = "My nix-based configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    homeManager.url = "github:nix-community/home-manager";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";  

    nixWsl.url = "github:nix-community/nixos-wsl";
    nixWsl.inputs.nixpkgs.follows = "nixpkgs";

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
        byte = mkSystem "byte" {
          system = "x86_64-linux";
          wsl = true;
        };

        titan = mkSystem "titan" {
          system = "x86_64-linux";
        };
      };
    };
}
