(*
 * This file is part of ocamljs, OCaml to Javascript compiler
 * Copyright (C) 2007-9 Skydeck, Inc
 * Copyright (C) 2010 Jake Donham
 * Original file (bytecomp/emitcode.ml in the Objective Caml source
 * distribution) is Copyright (C) INRIA.
 *
 * This program is free software released under the QPL.
 * See LICENSE for more details.
 *
 * The Software is provided AS IS with NO WARRANTY OF ANY KIND,
 * INCLUDING THE WARRANTY OF DESIGN, MERCHANTABILITY AND 
 * FITNESS FOR A PARTICULAR PURPOSE.
 *)

open Config
open Ocamljs_config
open Misc
open Asttypes
open Lambda
open Instruct
open Opcodes
open Cmo_format

(* Emission to a file *)

let to_file outchan unit_name (code, reloc) =
  output_string outchan cmjs_magic_number;
  let pos_depl = pos_out outchan in
  output_binary_int outchan 0;
  let pos_code = pos_out outchan in
  output_value outchan code; (* just marshal the AST *)
  let codesize = pos_out outchan - pos_code in

  let compunit =
    { cu_name = unit_name;
      cu_pos = pos_code;
      cu_codesize = codesize;
      cu_reloc = List.rev reloc;
      cu_imports = Env.imported_units();
      cu_primitives =
        List.map Primitive.byte_name !Translmod.primitive_declarations;
      cu_force_link = false;
      cu_debug = 0;
      cu_debugsize = 0 } in
  Btype.cleanup_abbrev ();              (* Remove any cached abbreviation
                                           expansion before saving *)
  let pos_compunit = pos_out outchan in
  output_value outchan compunit;
  seek_out outchan pos_depl;
  output_binary_int outchan pos_compunit

let to_packed_file outchan code =
  output_value outchan code;
  []
