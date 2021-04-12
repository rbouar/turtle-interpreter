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

let dimension = 800;;
let scale = 1;;
let sleep = 0.05;;

let create_window w h =
  open_graph (" " ^ string_of_int w ^ "x" ^ string_of_int h);
  set_window_title "GASP   -   by Romain & Luka";
  set_line_width 2;
  auto_synchronize true
;;

let reset_window () =
  clear_graph ();
;;

let move turtle =
  let x = int_of_float(turtle.pos.x) * scale in
  let y = int_of_float(turtle.pos.y) * scale in
  if turtle.pinceau then (Unix.sleepf(sleep);lineto x y) else moveto x y
;;

let convert_angle a =
  let conv_deg_rad = Float.pi /. 180. in
  let angle_float = float_of_int a in
  let rad_a = angle_float *. conv_deg_rad in
  (cos rad_a, sin rad_a)
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
  let nt = { pos = {x = nx; y = ny; a = t.pos.a}; pinceau = t.pinceau } in
  move nt; nt
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

(* interprète un programme *)
let rec interp prgm =
  let (var_l, instr) = prgm in
  let var_t = list_to_table var_l in
  interp_instr var_t instr

(* interprète une instruction *)
and interp_instr var_t instr =
  let turtle = { pos = {x = 0.; y = 0.; a = 90}; pinceau = false } in
  let rec aux var_t turtle instr = match instr with
    | Avance e -> avance turtle (interp_expr e var_t)
    | Tourne e -> tourne turtle (interp_expr e var_t)
    | HautPinceau -> hautpinceau turtle
    | BasPinceau -> baspinceau turtle
    | Assignation (v, e) -> let _ = assignation var_t v (interp_expr e var_t) in turtle
    | Bloc l -> List.fold_left (aux var_t) turtle l
    | Condition (expr, yes, no) -> if (interp_expr expr var_t) != 0 then aux var_t turtle yes else aux var_t turtle no
    | TantQue (cond, ins) as boucle -> if (interp_expr cond var_t) = 0 then turtle
                                       else let turtle' = aux var_t turtle ins in
                                            let eval = interp_expr cond var_t in
                                            if eval = 0 then turtle' else aux var_t turtle' boucle
  in aux var_t turtle instr

(* interprète une expression *)
and interp_expr e var_t = match e with
  | Nombre nb -> nb
  | Var v -> if Hashtbl.mem var_t v then Hashtbl.find var_t v else raise Not_found
  | EOpBin (e1, Plus, e2) -> (interp_expr e1 var_t) + (interp_expr e2 var_t)
  | EOpBin (e1, Moins, e2) -> (interp_expr e1 var_t) - (interp_expr e2 var_t)
  | EOpBin (e1, Fois, e2) -> (interp_expr e1 var_t) * (interp_expr e2 var_t)
  | EOpBin (e1, Div, e2) -> (interp_expr e1 var_t) / (interp_expr e2 var_t)
;;

let show prgm =
  create_window dimension dimension;
  reset_window ();
  let _ = interp prgm in
  let event = wait_next_event [Key_pressed] in
  match event.key with
  |_ -> close_graph ()
;;
