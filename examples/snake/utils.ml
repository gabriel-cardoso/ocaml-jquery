(* 
 * Utils module from https://github.com/OCamlPro/tryocaml/blob/master/ocp-jslib/utils.ml
 * http://www.ocamlpro.com - OCamlPro SAS
 *
 * (C) 2012 Fabrice Le Fessant - fabrice.le_fessant@inria.fr
 * (C) 2012 Cagdas Bozman - cagdas.bozman@ocamlpro.com
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

let doc = Dom_html.document

let window = Dom_html.window

let loc = Js.Unsafe.variable "location"

let _s s = Js.string s

let _f f = Js.wrap_callback f

let get_element_by_id id =
  Js.Opt.get (doc##getElementById (Js.string id)) (fun () -> assert false)

let set_by_id id s =
  let div = get_element_by_id id in
  div##innerHTML <- Js.string s

let set_div_by_id id s =
  try
    set_by_id id s
  with _ -> ()

let get_by_id id =
  let div = get_element_by_id id in
  Js.to_string div##innerHTML

let get_by_name id =
  let div =
    List.hd (Dom.list_of_nodeList (doc##getElementsByTagName (Js.string id))) in
  Js.to_string div##innerHTML

let jsnew0 (constr : 'a Js.t Js.constr) () =
  (Js.Unsafe.new_obj constr [| |] : 'a Js.t)

let jsnew1 (constr : ('a -> 'z Js.t) Js.constr) (a) =
  (Js.Unsafe.new_obj constr [|
    Js.Unsafe.inject (a : 'a)
                            |] : 'z Js.t)

let jsnew2 (constr : ('a -> 'b -> 'z Js.t) Js.constr) (a,b) =
  (Js.Unsafe.new_obj constr [|
    Js.Unsafe.inject (a : 'a);
    Js.Unsafe.inject (b : 'b);
                            |] : 'z Js.t)

let jsnew3 (constr : ('a -> 'b -> 'c -> 'z Js.t) Js.constr) (a,b,c) =
  (Js.Unsafe.new_obj constr [|
    Js.Unsafe.inject (a : 'a);
    Js.Unsafe.inject (b : 'b);
    Js.Unsafe.inject (c : 'c);
                            |] : 'z Js.t)

let setIntervalUntilFalse f time =
  let interval_id = ref None in
  let f () =
    if not (f ()) then
      match !interval_id with
          None -> ()
        | Some interval_id ->
          window##clearInterval (interval_id)
  in
  interval_id := Some (window##setInterval (_f f, time))

let setInterval f time =
  let interval_id = window##setInterval (_f f, time) in
  (fun _ -> window##clearInterval (interval_id))

let setTimeout f time =
  let interval_id = window##setTimeout (_f f, time) in
  (fun _ -> window##clearTimeout (interval_id))
