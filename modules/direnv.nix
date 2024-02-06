{ config, lib, ... }: 
let
  id = config.user.identifier;
  profile = config.home-manager.users.${id};
  home = profile.home.homeDirectory;
  devDir = profile.xdg.userDirs.extraConfig.XDG_DEV_DIR;
in {
  home-manager.users.${id} = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        whitelist.prefix = with lib.strings; [ 
          "${home}${removePrefix "$HOME" devDir}"
        ];
      };
    };
  };
}
