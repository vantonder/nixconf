{ config, ... }: {
  home-manager.users.${config.user.name} = {
    programs.git = {
      enable = true;
      userName = config.git.name;
      userEmail = config.git.email;
    };
  };
}
