{ config, lib, ... }: {
  options = with lib; {
    presets.system.gnome.enable = mkEnableOption (mdDoc "Gnome system preset");
  };

  config = lib.mkIf config.presets.system.gnome.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.gdm.enable = true;
  };
}
