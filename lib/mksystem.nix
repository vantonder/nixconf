{ inputs, nixpkgs, overlays }: host: { system, wsl ? false }:
let
  homeManager = inputs.homeManager.nixosModules.home-manager;
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
    (if wsl then inputs.nixWsl.nixosModules.wsl else {})
    { nixpkgs.overlays = overlays; }
    { _module.args = { inherit overlays wsl; }; }
  ];
}
