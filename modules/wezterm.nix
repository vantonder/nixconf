{ config, ... }: {
  home-manager.users.${config.user.identifier} = {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local config = {};

        config.enable_wayland = false;

        config.font_size = 12;
        config.font = wezterm.font 'JetBrains Mono';

        return config;
      '';
    };
  };
}
