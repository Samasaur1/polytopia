{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = [
    pkgs.gnumake
    pkgs.clang
    pkgs.lldb
    pkgs.gcc
    pkgs.gdb
    pkgs.cmake
    pkgs.git
  ];
}
