{ config, ... }: {
  home-manager.users.${config.user.identifier} = {
    programs.git = {
      enable = true;
      userName = config.git.author;
      userEmail = config.git.email;
    };
  };
}
