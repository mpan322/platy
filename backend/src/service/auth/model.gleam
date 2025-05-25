import gleam/json

pub type UserPublic {
  UserPublic(id: Int, email: String)
}

pub type UserPrivate {
  UserPrivate(id: Int, email: String)
}

pub type UserPrivatePass {
  UserPrivatePass(id: Int, email: String, pass: String)
}

pub fn remove_pass(user: UserPrivatePass) -> UserPrivate {
  UserPrivate(user.id, user.email)
}

pub fn json_user_prv(user: UserPrivate) -> json.Json {
  json.object([#("email", json.string(user.email)), #("id", json.int(user.id))])
}

pub fn json_user_pub(user: UserPublic) -> json.Json {
  json.object([#("email", json.string(user.email)), #("id", json.int(user.id))])
}
