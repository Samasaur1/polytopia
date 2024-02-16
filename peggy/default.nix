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
}
