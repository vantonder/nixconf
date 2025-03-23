{ ... }@_haumeaArgs:
{ config, pkgs, ... }@_nixosModuleArgs:
let
  dataDir = "/var/lib/media";
  group = "media";
  user = group;
in
{
  environment.systemPackages = with pkgs; [
    jellyfin-ffmpeg
    jellyfin-web
  ];

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

        redir /newsreader /newsreader/
        reverse_proxy /newsreader/* localhost:8080

        redir /series /series/
        reverse_proxy /series/* localhost:8989
      }
    '';
  };

  services.homepage-dashboard = {
    enable = true;
    environmentFile = "/private/homepage";
    bookmarks = [
      {
        Development = [
          { GitHub = [{ abbr = "GH"; href = "https://github.com"; }]; }
        ];
      }
    ];
    services = [
      {
        Media = [
          {
            Jellyfin = {
              description = "Media Server";
              href = "https://${config.networking.hostName}.tawny-snapper.ts.net/media";
              icon = "jellyfin.svg";
              widget = {
                integrations = [
                  {
                    color = "amber";
                    service_group = "Media";
                    service_name = "Radarr";
                    type = "radarr";
                  }
                  {
                    color = "teal";
                    service_group = "Media";
                    service_name = "Sonarr";
                    type = "sonarr";
                  }
                ];
                type = "calendar";
              };
            };
          }
          {
            Radarr = {
              description = "Movie Management";
              href = "https://${config.networking.hostName}.tawny-snapper.ts.net/movies";
              icon = "radarr.svg";
              widget = {
                key = "{{HOMEPAGE_VAR_RADARR}}";
                type = "radarr";
                url = "http://localhost:7878";
              };
            };
          }
          {
            Sonarr = {
              description = "Series Management";
              href = "https://${config.networking.hostName}.tawny-snapper.ts.net/series";
              icon = "sonarr.svg";
              widget = {
                key = "{{HOMEPAGE_VAR_SONARR}}";
                type = "sonarr";
                url = "http://localhost:8989";
              };
            };
          }
        ];
      }
      {
        Files = [
          {
            SABnzbd = {
              description = "Newsreader";
              href = "https://${config.networking.hostName}.tawny-snapper.ts.net/newsreader";
              icon = "sabnzbd-alt.svg";
              widget = {
                key = "{{HOMEPAGE_VAR_SABNZBD}}";
                type = "sabnzbd";
                url = "http://localhost:8080";
              };
            };
          }
        ];
      }
    ];
    settings = {
      headerStyle = "clean";
      hideVersion = true;
      title = "Dashboard";
      quicklaunch = {
        hideInternetSearch = true;
        hideVisitURL = true;
        showSearchSuggestions = true;
      };
    };
    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
    ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    inherit group user;
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

  users.groups.${group} = { };

  users.users.${user} = {
    isSystemUser = true;
    inherit group;
  };
}
