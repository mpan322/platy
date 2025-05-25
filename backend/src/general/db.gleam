import cake/adapter/postgres
import gleam/option.{Some}
import pog.{type Connection}

pub fn with_connection(callback callback: fn(Connection) -> a) -> a {
  postgres.with_connection(
    host: "localhost",
    port: 5432,
    username: "postgres",
    password: Some("postgres"),
    database: "user_test",
    callback:,
  )
}
