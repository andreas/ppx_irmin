open Ppxlib
open Ppx_irmin_lib

let ppx_name = "irmin"

let expand_str ~loc ~path:_ input_ast name =
  let (module S) = Ast_builder.make loc in
  let (module L) = (module Deriver.Located (S) : Deriver.S) in
  L.derive_str ?name input_ast

let expand_sig ~loc ~path:_ input_ast name =
  let (module S) = Ast_builder.make loc in
  let (module L) = (module Deriver.Located (S) : Deriver.S) in
  L.derive_sig ?name input_ast

let str_type_decl_generator =
  let args = Deriving.Args.(empty +> arg "name" (estring __)) in
  let attributes = Attributes.all in
  Deriving.Generator.make ~attributes args expand_str

let sig_typ_decl_generator =
  let args = Deriving.Args.(empty +> arg "name" (estring __)) in
  Deriving.Generator.make args expand_sig

let irmin =
  Deriving.add ~str_type_decl:str_type_decl_generator
    ~sig_type_decl:sig_typ_decl_generator ppx_name
