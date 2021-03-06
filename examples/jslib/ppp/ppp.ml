(* parse and pretty print Javascript *)

Format.set_margin 25;
try
  let ss = Jslib_parse.parse_stdin () in
  Jslib_pp.stmt Format.std_formatter ss;
  Format.fprintf Format.std_formatter "\n";
  Format.pp_print_flush Format.std_formatter ()
with e ->
  Format.eprintf "@[<v0>%a@]@." Camlp4.ErrorHandler.print e
