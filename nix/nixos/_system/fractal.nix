{ name, root, super, ... }@_haumeaArgs: {
  host = root.nixos.host.${name};

  profiles = [
    super.profile.media
    super.profile.server
  ];

  users = [ ];
}
