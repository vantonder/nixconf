{ config, lib, osConfig, ... }: with lib; {
  options = {
    presets.user.default.enable = mkOption {
      type = types.bool;
      description = "Whether to enable the default user preset.";
      default = true;
      example = true;
    };
  };

  config = mkIf config.presets.user.default.enable {
    home.stateVersion = osConfig.system.stateVersion;

    programs = {
      home-manager.enable = true;
    };
  };
}
