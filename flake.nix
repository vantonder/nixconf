{
  description = "My Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let 
      context = { ... }: rec {
        user.name = "putquo";
        user.description = "Preston van Tonder";
        git.name = user.description;
        git.email = "46090392+putquo@users.noreply.github.com";
      };
    in {
      nixosConfigurations = {
        titan = import ./hosts/titan { inherit inputs context; };
      };
    };
}
