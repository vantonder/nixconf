{ config, lib, pkgs, wsl, ... }: {
  networking.hostName = "byte";

  presets.system.base.enable = true;

  time.timeZone = "Europe/Amsterdam";

  users.toil.enable = true;

  system.stateVersion = "23.11";

  wsl.enable = lib.mkIf wsl true;
}
