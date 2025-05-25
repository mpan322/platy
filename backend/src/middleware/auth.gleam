import general/context.{type Context}
import wisp

pub fn auth_middleware(
  req: wisp.Request,
  _ctx: Context,
  handler: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  let cookie = wisp.get_cookie(req, "auth_token", wisp.PlainText)
  handler(req)
}
