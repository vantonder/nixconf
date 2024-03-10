{ config, lib, pkgs, ... }: {
  networking.hostName = "byte";

  time.timeZone = "Europe/Amsterdam";

  users.toil.enable = true;

  system.stateVersion = "23.11";
}
