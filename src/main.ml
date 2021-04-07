(* main.ml *)
open Interp

(* programme principal *)

let dimension = 800;;

let _ =  
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.s Lexer.main lexbuf in
  let _ = Printf.printf "Parse:\n%s\n" (Ast.programme_to_string ast) in
  create_window dimension dimension;
  reset_window ();;
