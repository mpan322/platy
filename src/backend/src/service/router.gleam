import general/context.{type Context}
import gleam/json
import service/auth/handler.{signup_handler}
import service/auth/router.{auth_router}
import wisp.{type Request, type Response}

fn router(req: Request, ctx: Context) -> Response {
  let resp = json.array([1, 2, 3], of: json.int) |> json.to_string_tree
  wisp.json_response(resp, 200)

  case wisp.path_segments(req) {
    ["auth", "sign-up"] -> signup_handler(req)
    _ -> todo
  }
}
