(*ocamlopt -o interp graphics.cmxa interp.ml*)

open Graphics

type position = {
  x: float;      (** position x *)
  y: float;      (** position y *)
  a: int;        (** angle of the direction *)
}

let dimension = 800;;

let create_window w h =
  open_graph (" " ^ string_of_int w ^ "x" ^ string_of_int h);
  set_window_title "L-SYSTEMES   -   by Lucas & Luka";
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

let avance pos dist =
  let float_dist = float_of_int dist in
  let (unit_x, unit_y) = convert_angle pos.a in
  let nx = pos.x +. unit_x *. float_dist in
  let ny = pos.y +. unit_y *. float_dist in
  {x = nx; y = ny; a = na}
;;

let tourne pos angle =
  {x = pos.x; y = pos.y; a = ((pos.a + angle) mod 360)}
;;

let interp e var_l val_l = 

let assignation v e var_l val_l =
  let rec find_var var_l index = match var_l with
    |[] -> Error
    |t::q when t = v -> index
    |t::q -> find_var q (index + 1)
  in
  let index = find_v var_l 0 in
  val_l.set index (interp e var_l val_l) in val_l
;;


let turtle ast =
  let (var_l, val_l) = ast in
  let pos_init = {x = 0.; y = 0.; z = 90} in
  let val_l = Array.make (List.length var_l) 0 in
  let rec parcours pos pinceau var_l val_l instr_l = match instr_l with
    | [] -> ()
    | Avance e :: q -> let i = interp e var_l val_l in parcours (avance pos i pinceau) pinceau var_l val_l q
    | Tourne e :: q -> let i = interp e var_l val_l in parcours (tourne pos i) pinceau var_l val_l q
    | HautPinceau :: q-> parcours pos false var_l val_l q
    | BasPinceau :: q-> parcours pos true var_l val_l q
    | Assignation (v, e) :: q -> let new_val_l = assignation v e var_l val_l in parcours pos pinceau var_l new_val_l q
  in parcours pos_init true var_l val_l instr_l
;;


(*let _ =
  create_window dimension dimension;
  while true do
    reset_window ()
  done;;
*)
