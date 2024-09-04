{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ./users.nix ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
  };

  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 10000;
        to = 11000;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 10000;
        to = 11000;
      }
    ];
  };

  networking.hostName = "peggy";

  virtualisation.docker = {
    enable = true;
  };

  users.users.sam.extraGroups = [ "docker" ];

  users.users.jimfix.packages = [
    (lib.hiPrio pkgs.python3)
    pkgs.python311
    pkgs.python310
    pkgs.python39
  ];

  programs.steam.enable = true;
  hardware.graphics.enable32Bit = true; # has no effect unless hardware.graphics.enable is set by something
}
