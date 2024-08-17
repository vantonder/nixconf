{ config, lib, pkgs, ... }: with lib; {
  options = {
    presets.system.dns.enable = mkOption {
      type = types.bool;
      description = "Whether to enable the DNS system preset.";
      default = false;
      example = true;
    };
  };

  config = mkIf config.presets.system.dns.enable {
    services.adguardhome.enable = true;
    services.adguardhome.openFirewall = true;
  };
}
