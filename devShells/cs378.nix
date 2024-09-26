{ config, pkgs, lib, ... }:

pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (ps: with ps; [
      jupyter
      numpy
      matplotlib
      tensorboard
      scikit-learn
      tqdm
    ] ++ (if (pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64) then with ps; [
      torch-bin
      torchvision-bin
    ] else with ps; [
      torch
      torchvision
    ])))
  ];

  name = "CS378";
}
