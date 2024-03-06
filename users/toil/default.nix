{ config, lib, pkgs, wsl, ...}:
let
  user = "toil";
  name = "Preston van Tonder";
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

      home.packages = with pkgs; [
        act
      ];

      programs = {
        git.userEmail = "prestonvantonder@studyportals.com";
        git.extraConfig.gpg.ssh.program = lib.mkIf wsl "/mnt/c/Users/PrestonvanTonder/AppData/Local/1Password/app/8/op-ssh-sign.exe";
        git.extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTceNH3o6069sOeRT/HmdBctb31UMdJXd1lgSYRytPy";

        vim.defaultEditor = true;
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
      };
    };

    programs = {
      _1password-gui.polkitPolicyOwners = [ user ];

      fish.enable = true;
    };

    systemd.services.docker-desktop-proxy.script = lib.mkIf wsl (lib.mkForce ''${config.wsl.wslConf.automount.root}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${config.wsl.wslConf.automount.root}/wsl/docker-desktop "C:\Program Files\Docker\Docker\resources"'');

    users.users.${user} = {
      extraGroups = [ "networkmanager" "wheel" ];
      isNormalUser = true;
      description = name;
      shell = pkgs.fish;
    };

    virtualisation.docker = lib.mkIf wsl {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
    };

    wsl.defaultUser = user;
    wsl.extraBin = with pkgs; [
      { src = "${coreutils}/bin/mkdir"; }
      { src = "${coreutils}/bin/cat"; }
      { src = "${coreutils}/bin/whoami"; }
      { src = "${coreutils}/bin/ls"; }
      { src = "${busybox}/bin/addgroup"; }
      { src = "${su}/bin/groupadd"; }
      { src = "${su}/bin/usermod"; }
    ];
  };
}
