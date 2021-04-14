(* main.ml *)

(* programme principal *)
let print_position outx lexbuf =
  Lexing.(
    let pos = lexbuf.lex_curr_p in
    Printf.fprintf outx "Line %d Col %d"
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol + 1)
  )

let _ =
  let lb = Lexing.from_channel stdin
  in
  try
    let ast =
      Parser.s Lexer.main lb
    in Typecheck.check_program ast; print_string "OK.\n"; Interp.show ast
  with
  | Lexer.Error msg ->
    Printf.fprintf stderr "%a: Lexer error reading %s\n" print_position lb msg;
    exit (-1)
  | Parser.Error ->
    Printf.fprintf stderr "%a: Syntax error\n" print_position lb;
    exit (-1)
  | Typecheck.Error s ->
    Printf.fprintf stderr "Type error: %s\n" s;
    exit (-1)
  | Interp.Error s ->
    Printf.fprintf stderr "Interpretation error: %s\n" s;
    exit (-1)
(* let _ =
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.s Lexer.main lexbuf in
  let _ = Printf.printf "Parse:\n%s\n" (Ast.programme_to_string ast) in
  Interp.show ast;; *)
