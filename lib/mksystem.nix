{ inputs, nixpkgs, overlays }: host: { system, user }:
let
  hostConfig = ../hosts/${host};
  userConfig = ../users/${user};
  userContext = ../users/${user}/context.nix;
  userHomeConfig = ../users/${user}/home.nix;

  options = ../options;

  systemFunc = nixpkgs.lib.nixosSystem;
  home-manager = inputs.home-manager.nixosModules;
in systemFunc rec {
  inherit system;

  modules = [
    { nixpkgs.overlays = overlays; }
    options
    hostConfig
    userConfig
    userContext
    home-manager.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHomeConfig;
    }
    {
      nix = {
        extraOptions = "warn-dirty = false";

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 1w";
        };

        settings = {
          auto-optimise-store = true;
          experimental-features = [ "nix-command" "flakes" ];
        };
      };
    }
    {
      _module.args = { 
        inherit overlays;
        currentUser = user;
      };
    }
  ];
}
