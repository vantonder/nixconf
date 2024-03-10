{ config, lib, pkgs, ... }: with lib; let
  wsl = config.wsl.enable;
in {
  options = {
    presets.system.base.enable = mkOption {
      type = types.bool;
      description = "Whether to enable the base system preset.";
      default = true;
      example = true;
    };
  };

  config = mkIf config.presets.system.base.enable {
    environment.systemPackages = with pkgs; [
      curl
      fzf
      git
      jq
      ripgrep
      tree
      unzip
      vim
      wget
      which
      zip
    ];

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" ]; })
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    programs._1password-gui.enable = mkIf (!wsl) true;

    nix.extraOptions = "warn-dirty = false";
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    nix.settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };

    nixpkgs.config.allowUnfree = true;

    virtualisation = mkIf (!wsl) {
      podman.enable = true;
      podman.defaultNetwork.settings.dns_enabled = true;
    };
  };
}
