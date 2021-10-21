Make sure that the type annotations are enough to make the set operation safe.

  $ standalone -as-pp main.ml > main.pp.ml
  $ ocamlfind ocamlc -package field_repr main.pp.ml
  File "main.ml", line 5, characters 19-22:
  5 |   Field_repr.set t var 42
                         ^^^
  Error: This expression has type (t, int, [ `immutable ]) Field_repr.t
         but an expression was expected of type
           (t, int, [ `mutable_ ]) Field_repr.t
         These two variant types have no intersection
  [2]
