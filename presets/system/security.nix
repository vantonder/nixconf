{ config, lib, pkgs, ...}: {
  options = with lib; {
    presets.system.security.enable = mkEnableOption (mdDoc "base system preset");
  };

  config = lib.mkIf config.presets.system.security.enable {
    security.pam.u2f = {
      enable = true;
      control = "sufficient";
      cue = true;
    };
  };
}
