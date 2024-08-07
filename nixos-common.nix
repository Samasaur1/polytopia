{ config, pkgs, lib, inputs, ... }:

{
  nix = {
    gc.dates = "weekly";
    settings.trusted-users = [ "@wheel" ];
  };

  users.users.sam = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBWoyO4UBSrOIKSPSo8hLnM6SKjji3+rIHF3hmmnQPNV sam" ];
  };

  # some way of adding other users

  environment.systemPackages = with pkgs; [
    coreutils
    diffutils
    findutils
    gnugrep
    gnumake
    gnupatch
    gnused
    inetutils
    time
  ];

  programs = {
    zsh.enable = true;
    fish.enable = true;
    bash = {
      completion.enable = true;
      promptInit = ''
        source ${./prompt.sh}
      '';
    };
    mosh.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    extraConfig = ''
      AcceptEnv DARKMODE
      AcceptEnv COLORTERM
    '';
  };

  services.tailscale.enable = true;
  # The following option (`boot.kernetl.sysctl = ...`) is IN PLACE OF `services.tailscale.useRoutingFeatures = "server'`. See the following bug for details:
  # https://github.com/NixOS/nixpkgs/issues/209119
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  system.autoUpgrade = {
    enable = true;
    flake = "github:Samasaur1/polytopia";
    dates = "04:35";
    allowReboot = true;
    rebootWindow = {
      lower = "04:30";
      upper = "05:00";
    };
    persistent = true; # default
    operation = "switch"; # default
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
