{ pkgs, lib, ... }:

pkgs.mkShell {
  packages = [
    pkgs.gnumake
    pkgs.clang
    pkgs.lldb
    pkgs.gcc_multi
    pkgs.cmake
    pkgs.git
    pkgs.glibc_multi.dev
  ] ++ (lib.optionals (!pkgs.stdenv.isDarwin) [
      pkgs.gdb
  ]);

  name = "CS368";
}
