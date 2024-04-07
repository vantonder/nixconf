{ config, lib, pkgs, ... }: with lib; let
  dataDir = "/var/lib/media";
  group = "media";
  user = group;
in {
  options = {
    presets.system.media.enable = mkOption {
      type = types.bool;
      description = "Whether to enable the media system preset.";
      default = false;
      example = true;
    };
  };

  config = mkIf config.presets.system.media.enable {
    services.caddy = {
      enable = true;
      configFile = pkgs.writeText "Caddyfile" ''
        titan.tawny-snapper.ts.net,
        localhost {
          redir /media /media/
          reverse_proxy /media/* localhost:8096

          redir /movies /movies/
          reverse_proxy /movies/* localhost:7878

          redir /newsreader /newsreader/
          reverse_proxy /newsreader/* localhost:8080

          redir /series /series/
          reverse_proxy /series/* localhost:8989
        }
      '';
    };

    services.jellyfin = {
      enable = true;
      openFirewall = true;
      inherit group user;
    };

    services.radarr = {
      enable = true;
      inherit group user;
    };

    services.sabnzbd = {
      enable = true;
      inherit group user;
    };

    services.sonarr = {
      enable = true;
      inherit group user;
    };

    services.tailscale.permitCertUid = "caddy";

    systemd.tmpfiles.settings.mediaDirs = {
      "${dataDir}/series"."d" = {
        mode = "770";
        inherit group user;
      };

      "${dataDir}/movies"."d" = {
        mode = "770";
        inherit group user;
      };

      "/var/lib/sabnzbd/downloads"."d" = {
        mode = "770";
        inherit group user;
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0770 ${user} ${group} - -"
    ];

    users.groups.${group} = { };

    users.users.${user} = { 
      isSystemUser = true;
      inherit group;
    };
  };
}
