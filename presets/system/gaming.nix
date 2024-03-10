{ config, lib, pkgs, ... }: with lib; {
  options = {
    presets.system.gaming.enable = mkEnableOption "the gaming system preset";
  };

  config = mkIf config.presets.system.gaming.enable {
    programs = {
      steam.enable = true;
    };
  };
}
