(*————————————————————————————————————————————————————————————————————————————
   Copyright (c) 2021 Craig Ferguson <me@craigfe.io>
   Copyright (c) 2021 Jules Aguillon <juloo.dsi@gmail.com>
   Distributed under the MIT license. See terms at the end of this file.
  ————————————————————————————————————————————————————————————————————————————*)

type mutable_ = [ `mutable_ ]
type immutable = [ `immutable ]
type (_, _, _) t = int

external identity : 'a -> 'a = "%identity"
external magic : 'a -> 'b = "%identity"

let index = identity

let get : type record data. record -> (record, data, _) t -> data =
 fun record index -> magic (Obj.field (magic record : Obj.t) index)

let set :
    type record data. record -> (record, data, [ `mutable_ ]) t -> data -> unit
    =
 fun record index data ->
  Obj.set_field (magic record : Obj.t) index (magic data : Obj.t)

let update : type record data. record -> (record, data, _) t -> data -> record =
 fun record index data ->
  let record : record = magic (Obj.dup (magic record : Obj.t)) in
  set record index data;
  record

module O = struct
  let ( .%() ) r t = get r t
  let ( .%()<- ) r t d = set r t d
  let with_ t d r = update r t d
end

module Obj = struct
  let unsafe_field_of_index = identity
end

(*————————————————————————————————————————————————————————————————————————————
   Copyright (c) 2021 Craig Ferguson <me@craigfe.io>
   Copyright (c) 2021 Jules Aguillon <juloo.dsi@gmail.com>

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
