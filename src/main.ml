let lexbuf = Lexing.from_channel stdin 

let ast = Parser.s Lexer.main lexbuf 

let _ = Printf.printf "Parse:\n%s\n" (Ast.programme_to_string ast)
