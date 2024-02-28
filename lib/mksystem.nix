{ inputs, nixpkgs, overlays }: host: { system }:
let
  homeManager = inputs.home-manager.nixosModules.home-manager;
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
    { nixpkgs.overlays = overlays; }
    { _module.args = { inherit overlays; }; }
  ];
}
