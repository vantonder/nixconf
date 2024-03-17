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

          programs = {
            neovim.enable = true;
            neovim.defaultEditor = true;
          };

          xdg.configFile = {
            "fish/functions".source = ./fish/functions;
            "fish/functions".recursive = true;

            "nvim".source = ./nvim;
            "nvim".recursive = true;

            "wezterm/wezterm.lua".source = ./wezterm/wezterm.lua;
            "wezterm/colors".source = ./wezterm/colors;
            "wezterm/colors".recursive = true;
          };
        };

        programs = {
          _1password-gui.polkitPolicyOwners = [ user ];

          fish.enable = true;
        };

        users.users.${user} = {
          extraGroups = [ "docker" "networkmanager" "wheel" ];
          isNormalUser = true;
          description = "Preston van Tonder";
          shell = pkgs.fish;
        };

        wsl.defaultUser = user;
      }
      withOverrides
    ]
  );
}
