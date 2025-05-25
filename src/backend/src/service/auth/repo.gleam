import gleam/json
import gleam/list
import gleam/result
import cake/adapter/postgres
import cake/select as s
import cake/where as w
import general/db
import utils/error.{type WebError, map_pog_error,not_found_error}
import utils/data.{type User}

pub fn login(email: String, password: String) -> Result(User, WebError) {
  use conn <- db.with_connection

  // construct query
  let where = [w.eq(w.col("email"), w.string(email)), w.eq(w.col("password"), w.string(password))] |>  w.and
  let query = s.new() 
    |> s.select_cols([
      "user.id",
      "user.email",
      "user.containers"
    ])
    |> s.from_table("user")
    |> s.where(where)
    |> s.to_query

    // execute query and map results
    postgres.run_read_query(query, data.de_user_db(), conn)
      |> result.map_error(map_pog_error)
      |> result.then(fn(lst) { 
        list.first(lst) 
        |> result.replace_error(not_found_error())
      })
}
