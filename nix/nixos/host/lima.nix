{ name, super, ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs: {
  imports = [
    super.hardware.notDetected
    super.platform."x86_64-linux"
  ];

  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [
    "ahci"
    "nvme"
    "sd_mod"
    "usbhid"
    "usb_storage"
    "xhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  fileSystems."/".device = "/dev/disk/by-label/able";
  fileSystems."/".fsType = "ext4";
  fileSystems."/boot".device = "/dev/disk/by-label/BOOT";
  fileSystems."/boot".fsType = "vfat";

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    nvidia-vaapi-driver
    vpl-gpu-rt
  ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;

  networking.hostName = name;

  services.fstrim.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  swapDevices = [ ];
  system.stateVersion = "23.11";
}
