{ pkgs }: {
  forUser = import ./user.nix { inherit pkgs; };
}
