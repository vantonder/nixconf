{ config, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.enable = true;

  hardware.pulseaudio.enable = false;

  networking.hostName = "titan";
  networking.networkmanager.enable = true;

  presets.system.base.enable = true;
  presets.system.i18n.dutch.enable = true;
  presets.system.gaming.enable = true;
  presets.system.gnome.enable = true;
  presets.system.nvidia.enable = true;
  presets.system.security.enable = true;

  security.rtkit.enable = true;

  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  services.xserver.displayManager.gdm.wayland = false;

  sound.enable = true;

  time.timeZone = "Europe/Amsterdam";

  users.putquo.enable = true;

  system.stateVersion = "23.11";
}
