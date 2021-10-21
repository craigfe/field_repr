Efficient run-time representations of OCaml record fields.

```ocaml
type mutable_ = |
type immutable = |

type ('record, 'data, 'mutable_) t
(** The type of runtime representations of OCaml record fields. *)

val get : 'record -> ('record, 'data, _) t -> 'data
(** [get record field] is [record.field], i.e. the data contained by (the field
    represented by) [field] in [record]. *)

val update : 'record -> ('record, 'data, _) t -> 'data -> 'record
(** [update record field data] is [{ record with field = data }], i.e. the
    record produced by setting (the field represented by) [field] to [data] in
    [record]. *)

val set : 'record -> ('record, 'data, mutable_) t -> 'data -> unit
(** [set record field data] performs [record.field <- data], i.e. updates the
    value of (the field represented by) [field] in [record] to [data]. *)
```

The implementation of these functions uses `Obj`. Comes with a PPX for safely
deriving run-time field representations:

```ocaml
type t = { foo : int; mutable bar : string } [@@deriving field_repr]

(* Generates: *)

val foo : (t, int, Field_repr.immutable) Field_repr.t
val bar : (t, string, Field_repr.mutable_) Field_repr.t
```

