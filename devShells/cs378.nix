{ config, pkgs, lib, ... }:

pkgs.mkShell {
  buildInputs = [
    (pkgs.python3.withPackages (ps: with ps; [ jupyter numpy torch matplotlib tensorboard ]))
  ];
}
