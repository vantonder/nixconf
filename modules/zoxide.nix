{ config, ..., }:
let
  id = config.user.identifier;
in {
  home-manager.users.${id} = {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd" "cd" ];
      enableZshIntegration = false;
      enableNushellIntegration = false;
    };
  };
}
