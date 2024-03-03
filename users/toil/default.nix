{ config, lib, overlays, pkgs, wsl, ...}: let
  user = "toil";
  name = "Preston van Tonder";
  devDir = "workspace";
in {
  options = with lib; {
    users.${user}.enable = mkEnableOption (mdDoc "studyportals preset");
  };

  config = lib.mkIf config.users.${user}.enable {
    home-manager.users.${user} = {
      _module.args = { inherit wsl; };

      imports = [
        ../../presets/user
      ];

      presets.user.base.enable = true;
      presets.user.development.enable = true;

      programs = {
        direnv.config.whitelist.prefix = [ "/home/${user}/${devDir}" ];

        firefox = {
          profiles.${user} = {
            id = 0;
            name = user;
            isDefault = true;
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              onepassword-password-manager
              ublock-origin
            ];
          };
        };

        git.userEmail = "prestonvantonder@studyportals.com";
        git.extraConfig.gpg.ssh.program = "/mnt/c/Users/PrestonvanTonder/AppData/Local/1Password/app/8/op-ssh-sign.exe";
        git.extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTceNH3o6069sOeRT/HmdBctb31UMdJXd1lgSYRytPy";

        starship.enableNushellIntegration = false;
        starship.enableIonIntegration = false;
        starship.enableZshIntegration = false;

        vim.enable = true;
        vim.defaultEditor = true;

        zoxide.enableNushellIntegration = false;
        zoxide.enableZshIntegration = false;
      };

      xdg = {
        configFile = lib.mkMerge [ 
          ({
            "fish/functions" = {
              source = ./fish/functions;
              recursive = true;
            };
          })
          (if (!wsl) then {
            "wezterm/wezterm.lua".source = lib.mkForce ./wezterm/wezterm.lua;
            "wezterm/colors" = {
              source = ./wezterm/colors;
              recursive = true;
            };

            "Yubico/u2f_keys".source = ./Yubico/u2f_keys;
          } else {})
        ];

        userDirs.extraConfig = { XDG_DEV_DIR = "$HOME/${devDir}"; };
      };
    };

    programs = {
      _1password-gui = lib.mkIf (!wsl) {
        enable = true;
        polkitPolicyOwners = [ user ];
      };

      fish.enable = true;
    };

    users.users.${user} = {
      extraGroups = [ "networkmanager" "wheel" ];
      isNormalUser = true;
      description = name;
      shell = pkgs.fish;
    };

    virtualisation = lib.mkIf (!wsl) {
      podman.enable = true;
      podman.defaultNetwork.settings.dns_enabled = true;
    };

    wsl.defaultUser = lib.mkIf wsl user;
  };
}
