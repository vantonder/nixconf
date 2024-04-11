{
  imports = [ ./hardware.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "fractal";
  networking.networkmanager.enable = true;

  presets.system.dns.enable = true;
  presets.system.i18n.dutch.enable = true;
  presets.system.media.enable = true;

  time.timeZone = "Europe/Amsterdam";

  users.lumen.enable = true;

  system.stateVersion = "23.11";
}
