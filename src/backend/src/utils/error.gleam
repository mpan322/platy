import gleam/string_tree
import pog
import gleam/dynamic/decode.{DecodeError, type DecodeError}
import gleam/json

pub type WebError {
  WebError(code: Int, message: String)
}

fn join(strs: List(String), delim: string) -> String {
  case strs {
    [] -> ""
    [s] -> s
    [x, ..xs] -> x <> join(xs, delim) 
  }
}

pub fn get_code(error: WebError) -> Int {
  let WebError(code, _) = error
  code
}

pub fn ser_error(error: WebError) -> string_tree.StringTree {
  let WebError(_, message) = error
  json.object([#("error", json.string(message))]) |> json.to_string_tree
}

pub fn map_req_decode_error(errors: List(DecodeError)) -> WebError {
  let map_error = fn(error) {
    let DecodeError(_, _, path) = error
    "invalid data at: " <> join(path, ".")
  }

  case errors {
    [] -> WebError(400, "unknown decoding error")
    [e, ..] -> WebError(400, map_error(e))
  }
}

pub fn map_pog_error(_: pog.QueryError) -> WebError {
  WebError(500, "database access error")
}

pub fn not_found_error() -> WebError {
  WebError(404, "no record found")
}

