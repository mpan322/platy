import service/auth/handler.{login_handler, signup_handler}
import wisp.{type Request, type Response}

pub fn auth_router(req: Request) -> Response {
  case wisp.path_segments(req) {
    ["login"] -> login_handler(req)
    ["sign-up"] -> signup_handler(req)
    ["verify"] -> todo
    _ -> todo
  }
}
