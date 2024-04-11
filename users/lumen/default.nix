{ config, schematics, ...}: schematics.forUser "lumen" {
  inherit config;
  withOverrides = {
    users.users.lumen.extraGroups = [ "docker" "media" ];
  };
}
