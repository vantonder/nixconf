{ config, pkgs, ... }: {
  home-manager.users.${config.user.identifier} = {
    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          onepassword-password-manager
          ublock-origin
        ];
      };
    };
  };
}
