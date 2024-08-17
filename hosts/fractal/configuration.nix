{ lib, ... }: {
  imports = [ ./hardware.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "fractal";
  networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  presets.system.automation.enable = true;
  presets.system.dns.enable = true;
  # presets.system.i18n.dutch.enable = true;
  presets.system.media.enable = true;

  # time.timeZone = "Europe/Amsterdam";

  users.lumen.enable = true;

  system.stateVersion = "23.11";
}
