{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-pinned-for-ripgrep-all.url =
      "github:nixos/nixpkgs/583df4e091fa9f4ceb7cea453fb8f59fb6bd047f";

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
      darwinConfigurations."imacs" = nix-darwin.lib.darwinSystem {
        modules =
          [ ./configuration.nix nix-index-database.nixosModules.nix-index ];
        specialArgs = { inherit inputs; };
      };

      darwinPackages = self.darwinConfigurations."simple".pkgs;

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
