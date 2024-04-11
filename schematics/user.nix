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
        };

        users.users.${user} = {
          extraGroups = [ "networkmanager" "wheel" ];
          isNormalUser = true;
        };
      }
      withOverrides
    ]
  );
}
