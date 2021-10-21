type t = { var : int } [@@deriving field_repr]

let () =
  let t = { var = 0 } in
  Field_repr.set t var 42
  (* We expect a type error *)
