{ ... }@_haumeaArgs:
{ config, pkgs, ... }@_nixosModuleArgs:
let
  dataDir = "/var/lib/media";
  group = "media";
  user = group;
in
{
  services.caddy = {
    enable = true;
    configFile = pkgs.writeText "Caddyfile" ''
      ${config.networking.hostName}.tawny-snapper.ts.net {
        redir /books /books/
        reverse_proxy /books/* localhost:8787

        redir /indexers /indexers/
        reverse_proxy /indexers/* localhost:9696

        redir /media /media/
        reverse_proxy /media/* localhost:8096

        redir /movies /movies/
        reverse_proxy /movies/* localhost:7878

        redir /music /music/
        reverse_proxy /music/* localhost:8686

        redir /navidrome /navidrome/
        reverse_proxy /navidrome/* localhost:4533

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

  services.lidarr = {
    enable = true;
    openFirewall = true;
    inherit group user;
  };

  services.navidrome = {
    enable = true;
    openFirewall = true;
    inherit group user;
    settings = {
      Address = "0.0.0.0";
      BaseUrl = "/navidrome";
      EnableInsightsCollector = false;
      MusicFolder = "${dataDir}/music";
    };
  };

  services.prowlarr.enable = true;

  services.radarr = {
    enable = true;
    openFirewall = true;
    inherit group user;
  };

  services.readarr = {
    enable = true;
    inherit group user;
  };

  services.sabnzbd = {
    enable = true;
    openFirewall = true;
    inherit group user;
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    inherit group user;
  };

  services.tailscale.permitCertUid = "caddy";

  systemd.tmpfiles.settings.mediaDirs = {
    "${dataDir}/audiobooks"."d" = {
      mode = "770";
      inherit group user;
    };

    "${dataDir}/books"."d" = {
      mode = "770";
      inherit group user;
    };

    "${dataDir}/movies"."d" = {
      mode = "770";
      inherit group user;
    };

    "${dataDir}/music"."d" = {
      mode = "770";
      inherit group user;
    };

    "${dataDir}/series"."d" = {
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

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  users.groups.${group} = { };

  users.users.${user} = {
    isSystemUser = true;
    inherit group;
    extraGroups = [ "video" "render" ];
  };
}
