(lang dune 2.8)
(generate_opam_files true)

(name ppx_field_repr)
(source (github CraigFe/ocaml-field-repr))
(license MIT)
(maintainers "Craig Ferguson <me@craigfe.io>")

(package
 (name ppx_field_repr)
 (synopsis "Efficient run-time representations of OCaml record fields")
 (depends
  (ppxlib (>= 0.16.0)) ;; Use OMP 2.0
  (alcotest :with-test)))
