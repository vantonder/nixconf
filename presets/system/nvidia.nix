{ config, lib, ... }: {
  options = with lib; {
    presets.system.nvidia.enable = mkEnableOption (mdDoc "Nvidia system preset");
  };

  config = lib.mkIf config.presets.system.nvidia.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;

      nvidiaSettings = true;

      open = false;

      package = config.boot.kernelPackages.nvidiaPackages.beta;

      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
