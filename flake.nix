{
  description = "Nix-based system configuration";

  inputs = {
    devenv.url = "github:cachix/devenv";
    devenv.inputs.flake-compat.follows = "flake-compat";
    devenv.inputs.flake-parts.follows = "flake-parts";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    flake-compat.url = "github:nixos/flake-compat";
    flake-compat.flake = false;

    flake-parts.url = "github:hercules-ci/flake-parts";
    haumea.url = "github:nix-community/haumea";

    haumea.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/nur";
    nur.inputs.flake-parts.follows = "flake-parts";
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { haumea, nixpkgs, ... }@inputs:
    let
      haum = haumea.lib.load {
        inputs = { inherit inputs; };
        src = ./nix;
        loader =
          [
            (
              let
                filenameFrom = path:
                  nixpkgs.lib.lists.last
                    (nixpkgs.lib.strings.splitString "/" (rmNixExtFrom path));
                rmNixExtFrom = path:
                  nixpkgs.lib.removeSuffix ".nix" (builtins.toString path);
              in
              {
                matches = name:
                  nixpkgs.lib.hasSuffix ".nix" name;
                loader = loaderInputs: path:
                  haumea.lib.loaders.default
                    (loaderInputs // { name = filenameFrom path; })
                    path;
              }
            )
          ];
      };
    in
    {
      devShells = haum.dev.shells;
      nixosConfigurations = haum.nixos.systems;
    };
}
