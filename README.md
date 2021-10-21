Efficient run-time representations of OCaml record fields.

```ocaml
type ('record, 'data) t
(** The type of runtime representations of OCaml record fields. *)

val get : 'record -> ('record, 'data) t -> 'data
(** [get record field] is [record.field], i.e. the data contained by (the field
    represented by) [field] in [record]. *)

val update : 'record -> ('record, 'data) t -> 'data -> 'record
(** [update record field data] is [{ record with field = data }], i.e. the
    record produced by setting (the field represented by) [field] to [data] in
    [record]. *)

val unsafe_set : 'record -> ('record, 'data) t -> 'data -> unit
(** [unsafe_set record field data] performs [record.field <- data], i.e. updates
    the value of (the field represented by) [field] in [record] to [data].

    NOTE: this results in undefined behaviour if the given record is not
    [mutable]. *)
```

The implementation of these functions uses `Obj`. Comes with a PPX for safely
deriving run-time field representations:

```ocaml
type t = { foo : int; bar : string } [@@deriving field_repr]

(* Generates: *)

val foo : (t, int) Field_repr.t
val bar : (t, string) Field_repr.t
```

