import general/context.{type Context}
import wisp.{type Request, type Response}

fn router(req: Request, ctx: Context) -> Response {
  case wisp.path_segments(req) {
    _ -> todo
  }
}
