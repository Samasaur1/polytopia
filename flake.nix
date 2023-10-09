{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-pinned-for-ripgrep-all.url = "github:nixos/nixpkgs/583df4e091fa9f4ceb7cea453fb8f59fb6bd047f";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-index-database, nix-darwin, ... }: {
    darwinConfigurations."imacs" = nix-darwin.lib.darwinSystem {
      modules = [ ./configuration.nix ];
      specialArgs = { inherit inputs; };
    };

    darwinPackages = self.darwinConfigurations."simple".pkgs;

    formatter = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed
      (system: nixpkgs.legacyPackages.${system}.nixfmt);
  };
}
