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

  outputs = {self, ...} @ inputs: let
    overlays = [];

    mkSystem = import ./lib/mksystem.nix {inherit inputs overlays;};

    supportedSystems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      inputs.nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import inputs.nixpkgs {inherit system;};
        });
  in {
    nixosConfigurations = {
      fractal = mkSystem "fractal" {
        system = "x86_64-linux";
      };
    };

    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          deadnix
          nixfmt
          statix
        ];
      };
    });
  };
}
