{ config, pkgs, lib, inputs, ... }:

{
# Allow "unfree" packages (unfree as in licensing)
  nixpkgs.config.allowUnfree = true;

  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  environment.etc."nix/inputs/polytopia".source = "${inputs.self}";
  nix = {
    registry = {
      # Pin nixpkgs to the rev used when rebuilding the config. This ensures that all usages of `nix profile install nixpkgs#hello` will use the same nixpkgs rev.
      nixpkgs.flake = inputs.nixpkgs;
      polytopia.flake = inputs.self;
    };
    nixPath = [ "/etc/nix/inputs" ];
    settings = {
      auto-optimise-store = true;
      experimental-features =
        [ "ca-derivations" "flakes" "nix-command" "repl-flake" ];
      keep-derivations = true;
      keep-outputs = true;
      substituters = [ "https://cache.garnix.io" ];
      trusted-public-keys =
        [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    };
    # Automatically clean out the Nix store weekly
    gc = {
      automatic = true;
      # on NixOS, set `dates = "weekly";`
      # on Darwin, set `interval = { Weekday = 1; Hour = 0; Minute = 0; };`
      options = "--delete-old";
    };
  };

  environment.systemPackages = with pkgs; [
    bat
    btop
    cloc
    cmake
    # coreutils # prefixed on darwin, not on nixos
    curl
    # diffutils # prefixed on darwin, not on nixos
    emacs
    file
    # findutils # prefixed on darwin, not on nixos
    fzf
    gawk # ?
    git
    # gnugrep # prefixed on darwin, not on nixos
    # gnumake # prefixed on darwin, not on nixos
    # gnupatch # prefixed on darwin, not on nixos
    # gnused # prefixed on darwin, not on nixos
    hyperfine
    imagemagick
    # inetutils # prefixed on darwin, not on nixos
    jq
    magic-wormhole
    micro
    nano
    neofetch
    neovim
    nmap
    pandoc
    ripgrep
    ripgrep-all
    screen
    # time # prefixed on darwin, not on nixos
    tmate
    tmux
    tree
    wget
    (ffmpeg_6-full.override { withUnfree = true; })
    # clang
    python3
    texlive.combined.scheme-full
    vim
  ];

  programs = {
    bash = {
      # enable = true; # yes on Darwin; option removed on NixOS
      enableCompletion = true;
    };
    zsh = {
      # does anyone use fucking zsh anyway?
      enable = true;
      # enableCompletion = true; # commented out on Darwin, enable on NixOS?
    };
    fish.enable = true;
    # vim/nvim
  };

  system.configurationRevision =
    if inputs.self ? rev then
      inputs.self.rev
    else
      throw "Refusing to build from a dirty Git tree!";
}
