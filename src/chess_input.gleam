// src/chess_input.gleam
import gleam/string

// External function to get input from the user
@external(erlang, "io", "get_line")
pub fn get_line(prompt: String) -> String

// Get user input with a prompt
pub fn get_user_input(prompt: String) -> String {
  get_line(prompt)
  |> string.trim()
}
