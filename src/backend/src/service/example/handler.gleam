import general/context.{type Context}
import general/error
import gleam/dynamic/decode
import gleam/http
import gleam/json
import gleam/result
import service/auth/model
import service/auth/repository.{create_user, get_by_email}
import wisp.{type Request, type Response}

fn login_decoder() -> decode.Decoder(#(String, String)) {
  use email <- decode.field("email", decode.string)
  use password <- decode.field("password", decode.string)
  decode.success(#(email, password))
}

fn signup_decoder() -> decode.Decoder(#(String, String)) {
  use email <- decode.field("email", decode.string)
  use password <- decode.field("password", decode.string)
  decode.success(#(email, password))
}

/// handle a user signup request
pub fn signup_handler(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use json <- wisp.require_json(req)

  // meat and potatoes
  let resp = {
    let res =
      decode.run(json, signup_decoder())
      |> result.replace_error(error.error_500())

    use #(email, password) <- result.try(res)
    use user <- result.try(create_user(email, password))
    Ok(model.json_user_prv(user))
  }

  // map responses to json
  case resp {
    Error(err) ->
      json_err(err.message)
      |> json.to_string_tree
      |> wisp.json_response(err.code)
    Ok(json) ->
      json.to_string_tree(json)
      |> wisp.json_response(200)
      |> wisp.set_cookie(req, "auth_cookie", "value", wisp.Signed, 60 * 60 * 24)
  }
}

// fn id_decoder() -> decode.Decoder(Int) {
//   use id <- decode.field("id", decode.int)
//   case id {
//     v if v >= 0 -> decode.success(id)
//     _ -> decode.failure(0, "id must be non-negative.")
//   }
// }

pub fn login_handler(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use json <- wisp.require_json(req)

  // meat and potatoes
  let resp = {
    let res =
      decode.run(json, login_decoder())
      |> result.replace_error(error.error_500())

    use #(email, password) <- result.try(res)
    use user <- result.try(get_by_email(email))

    case email == password {
      False -> Error(error.WebError(401, "incorrect email or password"))
      True -> user |> model.remove_pass |> model.json_user_prv |> Ok
    }
  }

  // map responses to json
  case resp {
    Error(err) ->
      json_err(err.message)
      |> json.to_string_tree
      |> wisp.json_response(err.code)
    Ok(json) ->
      json.to_string_tree(json)
      |> wisp.json_response(200)
  }
}

fn json_err(err: String) -> json.Json {
  json.object([#("error", json.string(err))])
}
