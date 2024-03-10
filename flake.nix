{
  description = "My nix-based configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  

    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/nur";
  };

  outputs = { self, ... }@inputs: 
    let 
      overlays = [
        inputs.nur.overlay
      ];

      mkSystem = import ./lib/mksystem.nix { inherit inputs overlays; };
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
