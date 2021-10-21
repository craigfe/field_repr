(lang dune 2.8)
(generate_opam_files true)
(cram enable)

(name field_repr)
(source (github CraigFe/ocaml-field-repr))
(license MIT)
(maintainers "Craig Ferguson <me@craigfe.io>")

(package
 (name field_repr)
 (synopsis "Efficient run-time representations of OCaml record fields")
 (depends
  (ocaml (>= 4.10.0))
  (ppxlib (>= 0.16.0)) ;; Use OMP 2.0
  (alcotest :with-test)))
