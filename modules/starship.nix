{ config, ... }: {
  home-manager.users.${config.user.identifier} = {
    programs.starship = {
      enable = true;
      settings = {
        username = {
          disabled = false;
          show_always = true;
          style_user = "white bold";
        };
      };
    };
  };
}
