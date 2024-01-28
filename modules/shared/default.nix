{ ... }: {
  imports = [ ./applications ./shell ];

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
}
