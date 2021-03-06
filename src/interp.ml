open Ast
open Graphics

exception Error of string

type position = {
  x: float;      (** position x *)
  y: float;      (** position y *)
  a: int;        (** angle of the direction *)
}

type turtle = {
  pos : position;
  pinceau : bool;
  (* states : (position * Graphics.color * int) list;
  color : Graphics.color; *)
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
  if(x >= 0 && x <= dimension && y >= 0 && y <= dimension) then
    if turtle.pinceau then
      (Unix.sleepf(sleep);lineto x y)
    else moveto x y
  else raise (Error ("The cursor is out of the canvas: ("^string_of_int x^","^string_of_int y^")"))
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
    | p::r -> Hashtbl.add t p None; parcours r
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
  { pos = t.pos; pinceau = false  }
;;

let baspinceau t =
  { pos = t.pos; pinceau = true }
;;

let epaisseur value =
  if value <= 0 then raise (Error ("Width value is negativ or zero: "^ string_of_int value))
  else set_line_width value
;;

let assignation tbl var value =
  if Hashtbl.mem tbl var then Hashtbl.replace tbl var (Some value)
  else raise (Error ("Variable not declared: "^var))
;;

let op_NON v =
  let b = v <> 0 in
  if not b then 1 else 0
;;

let op_OU v1 v2 =
  let b1 = v1 <> 0 in
  let b2 = v2 <> 0 in
  if b1 || b2 then 1 else 0
;;

let op_ET v1 v2 =
  let b1 = v1 <> 0 in
  let b2 = v2 <> 0 in
  if b1 && b2 then 1 else 0
;;

let op_COMP v1 v2 =
  if v1 = v2 then 1 else 0
;;

let op_DIFF v1 v2 =
  if v1 <> v2 then 1 else 0
;;

let op_SUP v1 v2 =
  if v1 > v2 then 1 else 0
;;

let op_INF v1 v2 =
  if v1 < v2 then 1 else 0
;;

let op_SUPEG v1 v2 =
  if v1 >= v2 then 1 else 0
;;

let op_INFEG v1 v2 =
  if v1 <= v2 then 1 else 0
;;


(* interpr??te un programme *)
let rec interp prgm =
  let (var_l, instr) = prgm in
  let var_t = list_to_table var_l in
  interp_instr var_t instr

(* interpr??te une instruction *)
and interp_instr var_t instr =
  let turtle = { pos = {x = 0.; y = 0.; a = 90}; pinceau = false } in
  let rec aux var_t turtle instr = match instr with
    | Avance e -> avance turtle (interp_expr e var_t)
    | Tourne e -> tourne turtle (interp_expr e var_t)
    | HautPinceau -> hautpinceau turtle
    | BasPinceau -> baspinceau turtle
    | Epaisseur e -> epaisseur (interp_expr e var_t); turtle
    | Assignation (v, e) -> let _ = assignation var_t v (interp_expr e var_t) in turtle
    | Bloc l -> List.fold_left (aux var_t) turtle l
    | SiAlorsSinon (expr, yes, no) -> if (interp_expr expr var_t) != 0 then aux var_t turtle yes else aux var_t turtle no
    | SiAlors (expr, ins) -> if (interp_expr expr var_t) != 0 then aux var_t turtle ins else turtle
    | TantQue (cond, ins) as boucle -> if (interp_expr cond var_t) = 0 then turtle
                                       else let turtle' = aux var_t turtle ins in
                                            let eval = interp_expr cond var_t in
                                            if eval = 0 then turtle' else aux var_t turtle' boucle
    | Couleur c -> let _ = Graphics.set_color c in turtle
    | Pour (variable, init, cond, next, ins) -> let turtle' = aux var_t turtle (Assignation (variable, init)) in
      if (interp_expr cond var_t) = 0 then turtle'
      else let turtle'' = aux var_t turtle' ins in
        aux var_t turtle'' (Pour (variable, next, cond, next, ins))
  in aux var_t turtle instr

(* interpr??te une expression *)
and interp_expr e var_t = match e with
  | Nombre nb -> nb
  | Var v -> if Hashtbl.mem var_t v then
               match Hashtbl.find var_t v with
               |Some value -> value
               |None -> raise (Error ("Variable without any value: "^v))
             else raise (Error ("Variable not declared: "^v))
  | Non e -> op_NON (interp_expr e var_t)
  | EOpBin (e1, Plus, e2) -> (interp_expr e1 var_t) + (interp_expr e2 var_t)
  | EOpBin (e1, Moins, e2) -> (interp_expr e1 var_t) - (interp_expr e2 var_t)
  | EOpBin (e1, Fois, e2) -> (interp_expr e1 var_t) * (interp_expr e2 var_t)
  | EOpBin (e1, Div, e2) -> (try (interp_expr e1 var_t) / (interp_expr e2 var_t) with Division_by_zero -> raise (Error ("Division by zero")))
  | EOpBin (e1, Et, e2) -> op_ET (interp_expr e1 var_t) (interp_expr e2 var_t)
  | EOpBin (e1, Ou, e2) -> op_OU (interp_expr e1 var_t) (interp_expr e2 var_t)
  | EOpBin (e1, Comp, e2) -> op_COMP (interp_expr e1 var_t) (interp_expr e2 var_t)
  | EOpBin (e1, Diff, e2) -> op_DIFF (interp_expr e1 var_t) (interp_expr e2 var_t)
  | EOpBin (e1, Sup, e2) -> op_SUP (interp_expr e1 var_t) (interp_expr e2 var_t)
  | EOpBin (e1, Inf, e2) -> op_INF (interp_expr e1 var_t) (interp_expr e2 var_t)
  | EOpBin (e1, SupEg, e2) -> op_SUPEG (interp_expr e1 var_t) (interp_expr e2 var_t)
  | EOpBin (e1, InfEg, e2) -> op_INFEG (interp_expr e1 var_t) (interp_expr e2 var_t)
  | Neg e -> (-(interp_expr e var_t))
;;

let show prgm =
  create_window dimension dimension;
  reset_window ();
  let _ = interp prgm in
  let event = wait_next_event [Key_pressed] in
  match event.key with
  |_ -> close_graph ()
;;
