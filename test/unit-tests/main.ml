open Field_repr.O

let check_int pos = Alcotest.(check ~pos int) ""
let check_string pos = Alcotest.(check ~pos string) ""

module X : sig
  type t = { mutable foo : int; mutable bar : string } [@@deriving field_repr]
end = struct
  type t = { mutable foo : int; mutable bar : string } [@@deriving field_repr]
end

open X

let check =
  let testable =
    Alcotest.testable
      (fun ppf { foo; bar } ->
        Format.fprintf ppf "@[{ foo = %d; bar = %S }@]" foo bar)
      ( = )
  in
  fun pos expected actual -> Alcotest.(check ~pos) testable "" expected actual

let test_get () =
  let x = { foo = 1; bar = "A" } in
  check_int __POS__ x.foo x.%(foo);
  check_string __POS__ x.bar x.%(bar);
  ()

let test_update () =
  let x = { foo = 1; bar = "A" } in
  check __POS__ { foo = 2; bar = "A" } (x.%(foo) <- 2);
  check __POS__ { foo = 1; bar = "B" } (x.%(bar) <- "B")

let test_set () =
  let x = { foo = 1; bar = "A" } in
  x.%!(foo) <- 2;
  check __POS__ { foo = 2; bar = "A" } x;
  x.%!(bar) <- "B";
  check __POS__ { foo = 2; bar = "B" } x;
  ()

let () =
  Alcotest.run __FILE__
    [
      ( "Field_repr",
        [
          Alcotest.test_case "get" `Quick test_get;
          Alcotest.test_case "update" `Quick test_update;
          Alcotest.test_case "set" `Quick test_set;
        ] );
    ]
