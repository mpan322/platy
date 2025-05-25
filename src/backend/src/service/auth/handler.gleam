import gleam/json
import utils/data
import service/auth/repo
import general/context.{type Context}
import gleam/http
import utils/error.{map_req_decode_error, get_code}
import gleam/dynamic/decode as de
import gleam/result
import wisp.{type Request, type Response}


fn apply_pair(fun: fn(a, b) -> c) -> fn(#(a, b)) -> c {
  fn (val) {
    let #(a, b) = val
    fun(a, b)
  }
} 

fn login_de() -> de.Decoder(#(String, String)) {
  use email <- de.field("email", de.string)
  use password <- de.field("password", de.string)
  de.success(#(email, password))
}

pub fn login_handler(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use body <- wisp.require_json(req)

  let res = de.run(body, login_de())
    |> result.map_error(map_req_decode_error)
    |> result.then(apply_pair(repo.login))

  case res {
    Ok(user) -> user 
      |> data.ser_user 
      |> json.to_string_tree 
      |> wisp.json_response(201)
    Error(err) -> err
      |> error.ser_error
      |> wisp.json_response(get_code(err))
  }
}

//
// fn signup_de() -> de.Decoder(#(String, String)) {
//   use email <- de.field("email", de.string)
//   use password <- de.field("password", de.string)
//   de.success(#(email, password))
// }
//
// /// handle a user signup request
// pub fn signup_handler(req: Request) -> Response {
//   use <- wisp.require_method(req, http.Post)
//   use body <- wisp.require_json(req)
//
//
//   // parse req body
//   let result = de.run(body, signup_de())
//
//   // query the database
//
//   // serialize dto
//
//   // send result
//
//   // meat and potatoes
//   let resp = {
//     let res =
//       de.run(js, signup_der())
//       |> result.replace_error(error.error_500())
//
//     use #(email, password) <- result.try(res)
//     use user <- result.try(create_user(email, password))
//     Ok(model.js_user_prv(user))
//   }
//
//   // map responses to js
//   case resp {
//     Error(err) ->
//       js_err(err.message)
//       |> js.to_string_tree
//       |> wisp.js_response(err.code)
//     Ok(js) ->
//       js.to_string_tree(js)
//       |> wisp.js_response(200)
//       |> wisp.set_cookie(req, "auth_cookie", "value", wisp.Signed, 60 * 60 * 24)
//   }
// }
//
// // fn id_der() -> de.der(Int) {
// //   use id <- de.field("id", de.int)
// //   case id {
// //     v if v >= 0 -> de.success(id)
// //     _ -> de.failure(0, "id must be non-negative.")
// //   }
// // }
//
// pub fn login_handler(req: Request) -> Response {
//   use <- wisp.require_method(req, http.Post)
//   use js <- wisp.require_json(req)
//
//   // meat and potatoes
//   let resp = {
//     let res =
//       de.run(js, login_de())
//       |> result.replace_error(error.error_500())
//
//     use #(email, password) <- result.try(res)
//     use user <- result.try(get_by_email(email))
//
//     case email == password {
//       False -> Error(error.WebError(401, "incorrect email or password"))
//       True -> user |> model.remove_pass |> model.json_user_prv |> Ok
//     }
//   }
//
//   // map responses to js
//   case resp {
//     Error(err) ->
//       js_err(err.message)
//       |> js.to_string_tree
//       |> wisp.json_response(err.code)
//     Ok(js) ->
//       js.to_string_tree(js)
//       |> wisp.json_response(200)
//   }
// }
//
// fn js_err(err: String) -> js.Json {
//   js.object([#("error", js.string(err))])
// }
