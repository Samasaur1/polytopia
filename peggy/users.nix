{ config, pkgs, lib, inputs, ... }:

{
  users.users = let
    bash = pkgs.bashInteractive;
    zsh = pkgs.zsh;
    fish = pkgs.fish;
  in lib.mapAttrs (_: shell: {
    isNormalUser = true;
    inherit shell;
  }) {
    vzaayer = bash;
    tuckerrtwomey = zsh;
    pnorton = bash;
    gabeh = bash;
    rileyshahar = fish;
    doranp = bash;
    kwilson = bash;
    tristanf = bash;
    jimfix = bash;
  };
}
