{ config, lib, pkgs, wsl, ...}:
let
  user = "putquo";
  name = "Preston van Tonder";
in {
  options = with lib; {
    users.${user}.enable = mkEnableOption (mdDoc "putquo preset");
  };

  config = lib.mkIf config.users.${user}.enable {
    home-manager.users.${user} = {
      _module.args = { inherit wsl; };

      imports = [
        ../../presets/user
      ];

      presets.user.development.enable = true;

      programs = {
        git.userEmail = "46090392+putquo@users.noreply.github.com";
        git.extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4z+GCnpEmPq2uRl1Ol8a83Xjmeiqk1q8XV3cZh7pWZ";

        vim.defaultEditor = true;
      };

      xdg = {
        configFile = {
          "fish/functions" = {
            source = ./fish/functions;
            recursive = true;
          };

          "wezterm/wezterm.lua".source = lib.mkForce ./wezterm/wezterm.lua;
          "wezterm/colors" = {
            source = ./wezterm/colors;
            recursive = true;
          };

          "Yubico/u2f_keys".source = ./Yubico/u2f_keys;
        };
      };
    };

    programs = {
      _1password-gui.polkitPolicyOwners = [ user ];

      fish.enable = true;
    };

    users.users.${user} = {
      extraGroups = [ "networkmanager" "wheel" ];
      isNormalUser = true;
      description = name;
      shell = pkgs.fish;
    };
  };
}
