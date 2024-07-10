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
    shells = [ pkgs.bashInteractive ];
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
      # shared-mime-info
      (time.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
    ];
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    interactiveShellInit = ''
      source ${./prompt.sh}
    '';
  };

  environment.etc."sudoers.d/pwfeedback".text = ''
    Defaults pwfeedback
  '';

  system.activationScripts.extraActivation.text = ''
    ln -sf "${pkgs.jdk11}/zulu-11.jdk" "/Library/Java/JavaVirtualMachines/"
  '';
  # Could also include these lines for more JDKs, but I'm choosing to only install 11
    # ln -sf "${pkgs.jdk8}/zulu-8.jdk" "/Library/Java/JavaVirtualMachines/"
    # ln -sf "${pkgs.jdk17}/zulu-17.jdk" "/Library/Java/JavaVirtualMachines/"

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "x86_64-darwin";
}
