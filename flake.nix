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

    reed-thesis-nix = {
      url = "github:Samasaur1/reed-thesis-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-index-database, nix-darwin, ... }:
    let
      allSystems = nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs allSystems;
      define = f: forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
        in
          f pkgs);
    in {
      nixosConfigurations = {
        peggy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common.nix
            ./nixos-common.nix
            ./nixos-graphical-common.nix
            ./peggy
          nix-index-database.nixosModules.nix-index
          ];
          specialArgs = { inherit inputs; };
        };
      };

      darwinConfigurations."imacs" = nix-darwin.lib.darwinSystem {
        modules = [
          ./common.nix
          ./darwin-common.nix
          nix-index-database.darwinModules.nix-index
        ];
        specialArgs = { inherit inputs; };
      };

      devShells = define (pkgs:
        let
          inherit (pkgs.lib)
            mapAttrs'
            nameValuePair
            removeSuffix
          ;
        in
          {
            default = pkgs.mkShell {
              buildInputs = [ pkgs.ansible ];
              shellHook = ''
                if ! [ $(id -u -n) == sam ]; then
                  cat <<< "This dev shell is meant for administration of CS department computers.
                You likely ran something along the lines of

                    nix develop polytopia

                This is probably not what you meant to run.
                Did you mean something like the following?

                    nix develop polytopia#cs221

                If you know what you're doing, feel free to ignore this message."
                fi
              '';
            };
          }
          //
          mapAttrs'
            (name: _:
              nameValuePair
                (removeSuffix ".nix" name)
                (pkgs.callPackage (./devShells + "/${name}") {})
            )
            (builtins.readDir ./devShells)
      );

      formatter = define (pkgs: pkgs.nixfmt);
    };
}
