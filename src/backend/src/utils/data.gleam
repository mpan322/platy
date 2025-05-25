import gleam/json as js
import gleam/dynamic/decode as de

pub type User {
  User(id: String, email: String, containers: List(Container))
}

pub type Container {
  Container(id: String, name: String, owner_id: String)
}

pub fn ser_container(container: Container) -> js.Json {
  let Container(id, name, owner_id) = container
  js.object([
    #("id", js.string(id)),
    #("name", js.string(name)),
    #("owner_id", js.string(owner_id))
  ])
}

pub fn ser_user(user: User) -> js.Json {
  let User(id, email, containers) = user
  js.object([
    #("id", js.string(id)),
    #("email", js.string(email)),
    #("containers", js.array(containers, of: ser_container))
  ])
}

pub fn de_container_json() -> de.Decoder(Container) {
  use id <- de.field("id", de.string)
  use name <- de.field("name", de.string)
  use owner_id <- de.field("owner_id", de.string)
  de.success(Container(id, name, owner_id))
}

pub fn de_container_db() -> de.Decoder(Container) {
  use id <- de.field("container.id", de.string)
  use name <- de.field("container.name", de.string)
  use owner_id <- de.field("conainter.owner_id", de.string)
  de.success(Container(id, name, owner_id))
}

pub fn de_user_json() -> de.Decoder(User) {
  use id <- de.field("id", de.string)
  use email <- de.field("email", de.string)
  use containers <- de.field("containers", de.list(de_container_json()))
  de.success(User(id, email, containers))
}

pub fn de_user_db() -> de.Decoder(User) {
  use id <- de.field("user.id", de.string)
  use email <- de.field("user.email", de.string)
  use containers <- de.field("user.containers", de.list(de_container_db()))
  de.success(User(id, email, containers))
}
