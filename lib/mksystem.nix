{ inputs, nixpkgs, overlays }: host: { system, wsl ? false }:
let
  homeManager = inputs.home-manager.nixosModules.home-manager;
  nixosWsl = inputs.nixos-wsl.nixosModules.wsl;
  hostConfig = ../hosts/${host}/configuration.nix;
  userConfig = ../users;

  presets = ../presets/system;

  systemFunc = nixpkgs.lib.nixosSystem;
in systemFunc rec {
  inherit system;

  modules = [
    homeManager
    hostConfig
    presets
    userConfig
    nixosWsl
    { nixpkgs.overlays = overlays; }
    { _module.args = { inherit overlays wsl; }; }
  ];
}
