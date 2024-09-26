{ pkgs, ... }:

pkgs.mkShell {
  packages = [
    pkgs.gnumake
    pkgs.clang
    pkgs.lldb
    pkgs.gcc
    pkgs.gdb
    pkgs.cmake
    pkgs.git
  ];

  name = "CS221";
}
