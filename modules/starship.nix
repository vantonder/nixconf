{ config, ... }: {
  home-manager.users.${config.user.identifier} = {
    programs.starship = {
      enable = true;
      enableNushellIntegration = false;
      enableIonIntegration = false;
      enableZshIntegration = false;
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
