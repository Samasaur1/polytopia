{ mkShell, ocamlPackages }:

mkShell {
  packages = with ocamlPackages; [ ocaml dune_3 findlib utop menhir ounit ];

  name = "CS384";
}
