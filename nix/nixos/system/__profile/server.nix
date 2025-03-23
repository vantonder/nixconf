{ ... }@_haumeaArgs:
{ lib, pkgs, ... }@_nixosModuleArgs: {
  environment.systemPackages = with pkgs; [
    btop
    curl
    vim
    wget
  ];

  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    warn-dirty = false
  '';

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.settings.trusted-users = [
    "@wheel"
  ];

  nixpkgs.config.allowUnfree = true;

  services.tailscale.enable = true;
}
