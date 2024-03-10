{ pkgs }: user: { config, withOverrides }: with pkgs.lib; {
  options = {
    users.${user}.enable = mkEnableOption "the '${user}' user";
  };

  config = mkIf config.users.${user}.enable (
    mkMerge [
      {
        home-manager.users.${user} = {
          imports = [
            ../presets/user
          ];

          xdg.configFile = {
            "fish/functions".source = ./fish/functions;
            "fish/functions".recursive = true;

            "wezterm/wezterm.lua".source = ./wezterm/wezterm.lua;
            "wezterm/colors".source = ./wezterm/colors;
            "wezterm/colors".recursive = true;
          };
        };

        programs = {
          _1password-gui.polkitPolicyOwners = [ user ];

          fish.enable = true;
        };

        systemd.services.docker-desktop-proxy.script = mkForce ''${config.wsl.wslConf.automount.root}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${config.wsl.wslConf.automount.root}/wsl/docker-desktop "C:\Program Files\Docker\Docker\resources"'';

        users.users.${user} = {
          extraGroups = [ "networkmanager" "wheel" ];
          isNormalUser = true;
          description = "Preston van Tonder";
          shell = pkgs.fish;
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
      }
      withOverrides
    ]
  );
}
