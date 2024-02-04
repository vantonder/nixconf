{
  description = "Nix-based configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  

    nur.url = "github:nix-community/nur";

    wezterm.url = "github:wez/wezterm?dir=nix&rev=5046fc225992db6ba2ef8812743fadfdfe4b184a";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let 
      context = rec {
        user.identifier = "putquo";
        user.name = "Preston van Tonder";
        git.author = user.name;
        git.email = "46090392+putquo@users.noreply.github.com";
      };

      overlays = [
        inputs.nur.overlay
      ];

      supportedSystems = [
        "x86_64-linux"
      ];
      forAllSystems = with nixpkgs.lib; genAttrs supportedSystems;

    in {
      nixosConfigurations = {
        titan = import ./hosts/titan { inherit inputs context overlays; };
      };
    };
}
