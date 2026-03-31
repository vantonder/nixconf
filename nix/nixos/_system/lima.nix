{ name, root, super, ... }@_haumeaArgs: {
  host = root.nixos.host.${name};

  profiles = [
    super.profile.ai
    super.profile.server
  ];

  users = [ ];
}
