{ config, lib, pkgs, ... }: with lib; {
  options = {
    presets.system.automation.enable = mkEnableOption "the automation system preset";
  };

  config = mkIf config.presets.system.automation.enable {
    environment.systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-protocol
      virt-viewer
    ];

    networking.bridges.br0.interfaces = [ "enp6s0" ];
    networking.firewall.allowedTCPPorts = [ 5900 ];
    networking.interfaces.br0.useDHCP = true;

    # TODO: remove this when https://github.com/NixOS/nixpkgs/issues/360592 is resolved
    nixpkgs.config.permittedInsecurePackages = [
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.36"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"
    ];

    virtualisation.libvirtd = with pkgs; {
      enable = true;
      qemu = {
        package = qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ 
          (OVMF.override {
            secureBoot = false;
            tpmSupport = true;
          }).fd
        ];
      };
    };

    programs.dconf.enable = true;
    programs.virt-manager.enable = true;
  };
}
