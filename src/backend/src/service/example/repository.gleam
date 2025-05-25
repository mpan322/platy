import cake/adapter/postgres
import cake/insert as i
import cake/select as s
import cake/where as w
import general/db
import general/error.{type WebError, WebError}
import gleam/dynamic/decode
import gleam/result
import service/auth/model.{
  type UserPrivate, type UserPrivatePass, type UserPublic, UserPrivate,
  UserPrivatePass, UserPublic,
}

pub fn create_user(
  email: String,
  password: String,
) -> Result(UserPrivate, WebError) {
  use conn <- db.with_connection

  // build the query
  let query =
    [[i.string(email), i.string(password)] |> i.row]
    |> i.from_values(table_name: "user", columns: ["email", "password"])
    |> i.returning(["email", "password"])
    |> i.to_query

  // define a user decoder
  let decoder = {
    use id <- decode.field(["id"], decode.int)
    use email <- decode.field(["email"], decode.string)
    decode.success(UserPrivate(id, email))
  }

  postgres.run_write_query(query, decoder, conn)
  |> result.replace_error(error.error_500())
  |> result.then(fn(lst) {
    case lst {
      [v] -> Ok(v)
      _ -> panic
    }
  })
}

pub fn get_by_email(email: String) -> Result(UserPrivatePass, WebError) {
  use conn <- db.with_connection

  // build the query
  let query =
    s.new()
    |> s.selects([
      s.col("user.name"),
      s.col("user.password"),
      s.col("user.email"),
      s.col("user.id"),
    ])
    |> s.from_table("user")
    |> s.where(w.eq(w.col("user.email"), w.string(email)))
    |> s.to_query

  // define a user decoder
  let decoder = {
    use id <- decode.field(["id"], decode.int)
    use email <- decode.field(["email"], decode.string)
    use password <- decode.field(["password"], decode.string)
    decode.success(UserPrivatePass(id, email, password))
  }

  postgres.run_read_query(query, decoder, conn)
  |> result.replace_error(error.error_500())
  |> result.then(fn(lst) {
    case lst {
      [v] -> Ok(v)
      [] -> Error(WebError(404, "no such user"))
      _ -> panic
    }
  })
}

pub fn get_prv_by_id(id: Int) -> Result(UserPrivate, WebError) {
  use conn <- db.with_connection

  // build the query
  let query =
    s.new()
    |> s.selects([s.col("user.name"), s.col("user.email"), s.col("user.id")])
    |> s.from_table("user")
    |> s.where(w.eq(w.col("user.id"), w.int(id)))
    |> s.to_query

  // define a user decoder
  let decoder = {
    use id <- decode.subfield(["user", "id"], decode.int)
    use email <- decode.subfield(["user", "email"], decode.string)
    decode.success(UserPrivate(id, email))
  }

  postgres.run_read_query(query, decoder, conn)
  |> result.replace_error(error.error_500())
  |> result.then(fn(lst) {
    case lst {
      [v] -> Ok(v)
      [] -> Error(WebError(404, "no such user"))
      _ -> panic
    }
  })
}
