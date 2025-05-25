import dot_env
import dot_env/env
import general/context
import gleam/erlang/process
import gleam/option
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load

  let secret_key = env.get_string_or("SECRET_KEY", "SECRET_KEY")
  let ctx = context.Context(option.None, context.None)
  let assert Ok(_) =
    wisp_mist.handler(fn(_) { todo }, secret_key)
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http

  process.sleep_forever()
}
