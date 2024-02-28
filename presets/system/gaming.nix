{ config, lib, pkgs, ... }: {
  options = with lib; {
    presets.system.gaming.enable = mkEnableOption (mdDoc "system gaming preset");
  };

  config = lib.mkIf config.presets.system.gaming.enable {
    programs = {
      steam.enable = true;
    };
  };
}
