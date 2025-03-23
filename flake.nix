{
  description = "Nix-based system configuration";

  inputs = {
    devenv.url = "github:cachix/devenv";

    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nur.url = "github:nix-community/nur";

    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, self, std, ... }@inputs:
    let
      system.harvest = target: path:
        nixpkgs.lib.attrsets.mapAttrs
          (systemName: { host, profiles, users }:
            nixpkgs.lib.nixosSystem {
              modules = [ host ] ++ profiles ++ users;
            }
          )
          (std.harvest target path)."x86_64-linux";
    in
    std.growOn
      {
        inherit inputs;
        cellsFrom = ./nix;
        cellBlocks = [
          # nixos
          (std.blockTypes.functions "host")
          (std.blockTypes.functions "system")
          (std.blockTypes.functions "user")
          # support
          (std.blockTypes.functions "lib")
          (std.blockTypes.functions "shell")
        ];
      }
      {
        devShells = std.harvest self [ "support" "shell" ];
        nixosConfigurations = system.harvest self [ "nixos" "system" ];
      };
}
