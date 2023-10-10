{ config, pkgs, inputs, ... }:

{
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

# Allow "unfree" packages (unfree as in licensing)
  nixpkgs.config.allowUnfree = true;

  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  nix = {
    # Pin nixpkgs to the rev used when rebuilding the config. This ensures that all usages of `nix profile install nixpkgs#hello` will use the same nixpkgs rev.
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "/etc/nix/inputs" ];
    settings = {
      auto-optimise-store = true;
      experimental-features =
        [ "ca-derivations" "flakes" "nix-command" "repl-flake" ];
      keep-derivations = true;
      keep-outputs = true;
    };
    # Automatically clean out the Nix store weekly
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-old";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # bash-completion # handled by programs.bash.enableCompletion
      bat
      btop
      cloc
      cmake
      coreutils-prefixed
      curl
      (diffutils.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
        doCheck = false;
      }))
      emacs
      file
      (findutils.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
      fzf
      gawk # note that this provides both gawk and awk, overriding macOS' /usr/bin/awk. there's also gawkInteractive
      git
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
      hyperfine
      imagemagick
      (inetutils.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
      # jdk11 # this provides the command-line tools, but doesn't do enough for macOS to recognize the installation
      jq
      magic-wormhole
      micro
      nano
      neofetch
      neovim
      nmap
      pandoc
      ripgrep
      inputs.nixpkgs-pinned-for-ripgrep-all.legacyPackages.x86_64-darwin.ripgrep-all
      screen
      # shared-mime-info
      (time.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ])
          ++ [ "--program-prefix=g" ];
      }))
      tmate
      tmux
      tree
      wget
      (ffmpeg_6-full.override { withUnfree = true; })
      # llvmPackages_latest.clang
      python3
      texlive.combined.scheme-full
      vim
    ];
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };
    zsh = {
      enable = true;
      # enableCompletion = true;
    };
    fish = { enable = true; };
    # vim/nvim
  };

  system.configurationRevision =
    if inputs.self ? rev then
      inputs.self.rev
    else
      throw "Refusing to build from a dirty Git tree!";

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "x86_64-darwin";
}
