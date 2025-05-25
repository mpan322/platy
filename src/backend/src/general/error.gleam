pub type WebError {
  WebError(code: Int, message: String)
}

pub fn error_500() -> WebError {
  WebError(500, "internal server error.")
}
