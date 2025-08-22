// src/chess_parser.gleam
import chess_types as types
import gleam/list
import gleam/string

// Parses a move string (e.g., "e2->e4") into a structured Move type.
pub fn parse_move(input: String) -> Result(types.Move, String) {
  let trimmed = string.trim(input)
  let parts = string.split(trimmed, "->")

  case parts {
    [from_str, to_str] -> {
      case
        parse_coordinate(string.trim(from_str)),
        parse_coordinate(string.trim(to_str))
      {
        Ok(from), Ok(to) -> Ok(types.Move(from, to))
        Error(e), _ -> Error(e)
        _, Error(e) -> Error(e)
      }
    }
    _ -> Error("Invalid move format. Use format 'a1->b2'.")
  }
}

// Parse just a coordinate (for suggesting moves)
pub fn parse_coordinate_only(input: String) -> Result(#(Int, Int), String) {
  parse_coordinate(string.trim(input))
}

// Converts a coordinate string like "e4" to a tuple #(4, 3)
// and handles potential errors.
fn parse_coordinate(input: String) -> Result(#(Int, Int), String) {
  let chars = string.to_graphemes(input)
  case chars {
    [col_char, row_char] -> {
      case
        types.char_to_column(string.lowercase(col_char)),
        types.char_to_row(row_char)
      {
        Ok(column), Ok(row) -> Ok(#(column, row))
        Error(e), _ -> Error(e)
        _, Error(e) -> Error(e)
      }
    }
    _ -> Error("Coordinate must be exactly two characters (e.g., 'e4')")
  }
}

// Format a coordinate as a string
pub fn format_coordinate(coord: #(Int, Int)) -> String {
  let #(col, row) = coord
  types.column_to_char(col) <> types.row_to_char(row)
}
