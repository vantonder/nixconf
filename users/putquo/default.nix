{ pkgs, ...}: 
let
  context = import ./context.nix;
in {
  users.users.${context.user} = {
    isNormalUser = true;
    description = context.name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.fish;
  };
  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ context.user ];
    };

    fish.enable = true;

    steam.enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = context.user;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
