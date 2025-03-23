{ cell, name, super, ... }@_haumeaArgs: {
  host = cell.host.${name};

  profiles = [
    super.profile.media
    super.profile.server
  ];

  users = [ ];
}
