open Ast
open Graphics

type position = {
  x: float;      (** position x *)
  y: float;      (** position y *)
  a: int;        (** angle of the direction *)
}

type turtle = {
  pos : position;
  pinceau : bool;
  (* states : (position * Graphics.color * int) list;
  color : Graphics.color;
  width : int; *)
}

let create_window w h =
  open_graph (" " ^ string_of_int w ^ "x" ^ string_of_int h);
  set_window_title "GASP   -   by Romain & Luka";
  set_font "-*-fixed-medium-r-semicondensed-*-25-*-*-*-*-*-iso8859-1";
  set_line_width 2;
  auto_synchronize true
;;

let reset_window () =
  clear_graph ();
;;

let convert_angle a =
  let conv_deg_rad = Float.pi /. 180. in
  let angle_float = float_of_int a in
  let rad_a = angle_float *. conv_deg_rad in
  (-.(sin rad_a), cos rad_a)
;;

(* list.iter *)
let list_to_table l =
  let t = Hashtbl.create (List.length l) in
  let rec parcours l = match l with
    | [] -> t
    | p::r -> Hashtbl.add t p 0; parcours r
  in parcours l
;;

let avance t dist =
  let float_dist = float_of_int dist in
  let (unit_x, unit_y) = convert_angle t.pos.a in
  let nx = t.pos.x +. unit_x *. float_dist in
  let ny = t.pos.y +. unit_y *. float_dist in
  { pos = {x = nx; y = ny; a = t.pos.a};
    pinceau = t.pinceau }
;;

let tourne t angl =
  { pos = {x = t.pos.x; y = t.pos.y; a = t.pos.a + angl};
    pinceau = t.pinceau }
;;

let hautpinceau t =
  { pos = t.pos; pinceau = false }
;;

let baspinceau t =
  { pos = t.pos; pinceau = true }
;;

let assignation tbl var value =
  if Hashtbl.mem tbl var then
    Hashtbl.replace tbl var value
  else raise Not_found
;;

let rec interp prgm =
  let (var_l, instr_l) = prgm in
  let var_t = list_to_table var_l in
  interp_instr var_t instr_l

and interp_instr var_t instr_l =
  let turtle = { pos = {x = 0.; y = 0.; a = 90}; pinceau = false } in
  let rec aux turtle var_t instr_l = match instr_l with
    | [] -> ()
    | Avance e :: q -> aux (avance turtle (interp_expr e var_t)) var_t q
    | Tourne e :: q -> aux (tourne turtle (interp_expr e var_t)) var_t q
    | HautPinceau :: q -> aux (hautpinceau turtle) var_t q
    | BasPinceau :: q -> aux (baspinceau turtle) var_t q
    | Assignation (v, e) :: q -> (assignation var_t v (interp_expr e var_t)); aux turtle var_t q
  in aux turtle var_t instr_l

and interp_expr e var_t = match e with
  | Nombre nb -> nb
  | Var v -> if Hashtbl.mem var_t v then Hashtbl.find var_t v else raise Not_found
  | EOpBin (e1, Plus, e2) -> (interp_expr e1 var_t) + (interp_expr e2 var_t)
  | EOpBin (e1, Moins, e2) -> (interp_expr e1 var_t) - (interp_expr e2 var_t)
;;

