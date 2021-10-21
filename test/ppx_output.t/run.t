What the PPX does:

  $ standalone -impl - <<END
  > type t = { foo : int; bar : bool } [@@deriving field_repr]
  > END
  type t = {
    foo: int ;
    bar: bool }[@@deriving field_repr]
  include
    struct
      let _ = fun (_ : t) -> ()
      let foo =
        (Field_repr.Obj.unsafe_field_of_index 0 : (t, int) Field_repr.t)
      let _ = foo
      let bar =
        (Field_repr.Obj.unsafe_field_of_index 1 : (t, bool) Field_repr.t)
      let _ = bar
    end[@@ocaml.doc "@inline"][@@merlin.hide ]

With a mutable field:

  $ standalone -impl - <<END
  > type t = { mutable m : int } [@@deriving field_repr]
  > END
  type t = {
    mutable m: int }[@@deriving field_repr]
  include
    struct
      let _ = fun (_ : t) -> ()
      let m = (Field_repr.Obj.unsafe_field_of_index 0 : (t, int) Field_repr.t)
      let _ = m
    end[@@ocaml.doc "@inline"][@@merlin.hide ]
