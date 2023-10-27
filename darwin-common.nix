{ config, pkgs, inputs, ... }:

{
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  nix.gc.interval = {
    Weekday = 1;
    Hour = 0;
    Minute = 0;
  };

  environment = {
    systemPackages = with pkgs; [
      coreutils-prefixed
      (diffutils.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
        doCheck = false;
      }))
      (findutils.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
      # gawk # note that this provides both gawk and awk, overriding macOS' /usr/bin/awk. there's also gawkInteractive
      # (gnugrep.overrideAttrs (old: { configureFlags = (old.configureFlags or []) ++ [ "--program-prefix=g" ]; }))
      (gnumake.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
      (gnupatch.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
      (gnused.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
      (inetutils.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
      # jdk11 # this provides the command-line tools, but doesn't do enough for macOS to recognize the installation
      # shared-mime-info
      (time.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
    ];
  };

  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      source ${./prompt.sh}
    '';
  };

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "x86_64-darwin";
}
