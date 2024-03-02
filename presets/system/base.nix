{ config, lib, pkgs, ...}: {
  options = with lib; {
    presets.system.base.enable = mkEnableOption (mdDoc "base system preset");
  };

  config = lib.mkIf config.presets.system.base.enable {
    environment.systemPackages = with pkgs; [
      curl
      git
      vim
      wget
    ];

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };

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

    nixpkgs.config.allowUnfree = true;
  };
}
