(*————————————————————————————————————————————————————————————————————————————
   Copyright (c) 2021 Craig Ferguson <me@craigfe.io>
   Distributed under the MIT license. See terms at the end of this file.
  ————————————————————————————————————————————————————————————————————————————*)

open Ppxlib
open Ast_builder.Default

let namespace = "ppx_fields_repr"
let raise_errorf ~loc fmt = Location.raise_errorf ~loc ("%s: " ^^ fmt) namespace

let type_of_label record_type label =
  let loc = label.pld_loc in
  let field_type = label.pld_type
  and mutable_flag =
    match label.pld_mutable with
    | Immutable -> [%type: Field_repr.immutable]
    | Mutable -> [%type: Field_repr.mutable_]
  in
  [%type: ([%t record_type], [%t field_type], [%t mutable_flag]) Field_repr.t]

type field = { name : label loc; loc : location; data : core_type }

(** Raise an error if the declaration is not of a record, or if the record type
    is [private]. *)
let fields_of_type_declaration ~loc tdecl : field list =
  let tdecl = name_type_params_in_td tdecl in
  let labels =
    match tdecl.ptype_kind with
    | Ptype_record x -> x
    | Ptype_open | Ptype_variant _ | Ptype_abstract ->
        raise_errorf ~loc "type must be a record declaration."
  in
  if tdecl.ptype_private = Private then
    raise_errorf ~loc "record type must not be private.";
  let record_type = core_type_of_type_declaration tdecl in
  ListLabels.map labels ~f:(fun label ->
      {
        name = label.pld_name;
        loc = label.pld_loc;
        data = type_of_label record_type label;
      })

let str_type_decl ~loc ~path:_ (_, tdecls) =
  ListLabels.concat_map tdecls ~f:(fun tdecl ->
      fields_of_type_declaration ~loc tdecl
      |> ListLabels.mapi ~f:(fun pos { name; loc; data } ->
             let repr =
               [%expr Field_repr.Obj.unsafe_field_of_index [%e eint ~loc pos]]
             in
             pstr_value ~loc Nonrecursive
               [
                 value_binding ~loc ~pat:(ppat_var ~loc name)
                   ~expr:(pexp_constraint ~loc repr data);
               ]))

let sig_type_decl ~loc ~path:_ (_, tdecls) =
  ListLabels.concat_map tdecls ~f:(fun tdecl ->
      fields_of_type_declaration ~loc tdecl
      |> ListLabels.map ~f:(fun { name; loc; data } ->
             psig_value ~loc (value_description ~loc ~name ~type_:data ~prim:[])))

let () =
  let open Deriving in
  ignore
    (add
       ~str_type_decl:(Generator.make Args.empty str_type_decl)
       ~sig_type_decl:(Generator.make Args.empty sig_type_decl)
       "field_repr")

(*————————————————————————————————————————————————————————————————————————————
   Copyright (c) 2021 Craig Ferguson <me@craigfe.io>

   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
   THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
   DEALINGS IN THE SOFTWARE.
  ————————————————————————————————————————————————————————————————————————————*)
