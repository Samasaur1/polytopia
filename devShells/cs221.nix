{ pkgs, lib, ... }:

pkgs.mkShell {
  packages = [
    pkgs.gnumake
    pkgs.clang
    pkgs.lldb
    pkgs.gcc
    pkgs.cmake
    pkgs.git
  ] ++ (lib.optionals (!pkgs.stdenv.isDarwin) [
      pkgs.gdb
  ]);

  name = "CS221";
}
