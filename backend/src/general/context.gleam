import gleam/option.{type Option}

pub type Auth {
  Admin
  User
  None
}

pub type Context {
  Context(id: Option(Int), auth: Auth)
}
