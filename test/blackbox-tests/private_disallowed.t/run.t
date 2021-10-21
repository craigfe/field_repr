Running the PPX on a `private` record type is forbidden:

  $ standalone -impl - <<END
  > type t = private { foo : int } [@@deriving field_repr]
  > END
  File "-", line 1, characters 0-54:
  Error: ppx_fields_repr: record type must not be private.
  [1]
