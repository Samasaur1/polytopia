{ mkShell, ocamlPackages }:

mkShell {
  buildInputs = with ocamlPackages; [ ocaml dune_3 findlib utop menhir ounit ];
}
