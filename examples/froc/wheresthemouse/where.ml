module D = Dom
module F = Froc_dom
module E = Froc_dom.Event
module B = Froc_dom.Behavior

class type console =
object
  method log : string -> unit
end

let console = (Ocamljs.var "console" : console)

let (>>=) = B.(>>=)

let onload () =
  console#log "onload";
  B.attach_innerHTML
    (D.document#getElementById "Mleft")
    (B.mouse >>= fun (x, y) -> B.return (string_of_int x));
  B.attach_innerHTML
    (D.document#getElementById "Mtop")
    (B.mouse >>= fun (x, y) -> B.return (string_of_int y))

;;

D.window#_set_onload (Ocamljs.jsfun onload)