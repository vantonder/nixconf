{ cell, name, super, ... }@_haumeaArgs: {
  host = cell.host.${name};

  profiles = [
    super.profile.ai
    super.profile.server
  ];

  users = [ ];
}
