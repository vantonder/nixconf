{ config, ... }: {
  imports = [
    ./1password.nix
    ./direnv.nix
    ./firefox.nix
    ./fish.nix
    ./git.nix
    ./podman.nix
    ./starship.nix
    ./vim.nix
    ./wezterm.nix
  ];

  nix = {
    extraOptions = "warn-dirty = false";

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Use the system-level nixpkgs, instead of Home Manager's 
  home-manager.useGlobalPkgs = true;
  # Install packages to /etc/profiles instead of ~/.nix-profile 
  # Useful for when using multiple profiles for one user 
  home-manager.useUserPackages = true;

  # A good fallback
  home-manager.users.${config.user.identifier} = {
    programs.bash.enable = true;
  };
}
