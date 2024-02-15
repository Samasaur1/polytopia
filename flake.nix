{
  description = "The Nix config for Polytopia";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-index-database, nix-darwin, ... }:
    let
      allSystems = nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs allSystems;
    in {
      nixosConfigurations = {
        peggy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common.nix
            ./nixos-common.nix
            ./nixos-graphical-common.nix
            ./peggy
          ];
          specialArgs = { inherit inputs; };
        };
      };

      darwinConfigurations."imacs" = nix-darwin.lib.darwinSystem {
        modules = [
          ./common.nix
          ./darwin-common.nix
          nix-index-database.nixosModules.nix-index
        ];
        specialArgs = { inherit inputs; };
      };

      devShells = forAllSystems (system:
        with nixpkgs.lib;
        mapAttrs' (name: _:
          nameValuePair (removeSuffix ".nix" name)
          (nixpkgs.legacyPackages.${system}.callPackage
            (./devShells + "/${name}") { })) (builtins.readDir ./devShells));

      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
