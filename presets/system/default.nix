{ config, lib, pkgs, ... }: with lib; {
  imports = [
    ./i18n
    ./media.nix
  ];

  options = {
    presets.system.default.enable = mkOption {
      type = types.bool;
      description = "Whether to enable the default system preset.";
      default = true;
      example = true;
    };
  };

  config = mkIf config.presets.system.default.enable {
    environment.systemPackages = with pkgs; [
      btop
      curl
      fzf
      git
      jq
      rclone
      ripgrep
      tailscale
      tree
      unzip
      vim
      wireguard-tools
      wget
      which
      zip
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

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

    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        pull.rebase = true;
        user.name = "Preston van Tonder";
        user.email = "46090392+putquo@users.noreply.github.com";
      };
    };

    services.tailscale.enable = true;

    virtualisation = {
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
