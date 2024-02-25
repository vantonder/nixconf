{ pkgs, currentUser, ...}: {
  users.users.${currentUser}.shell = pkgs.fish;
  programs.fish.enable = true;
}
