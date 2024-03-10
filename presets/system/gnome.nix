{ config, lib, ... }: with lib; {
  options = {
    presets.system.gnome.enable = mkEnableOption "the GNOME system preset";
  };

  config = mkIf config.presets.system.gnome.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.gdm.enable = true;
  };
}
