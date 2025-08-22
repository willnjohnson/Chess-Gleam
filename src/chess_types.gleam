// src/chess_types.gleam
// Represents the two colors of the pieces.
pub type Color {
  White
  Black
}

// Represents the kind of chess piece.
pub type Kind {
  Pawn
  Rook
  Knight
  Bishop
  Queen
  King
}

// A chessboard square can either be empty or contain a piece.
pub type Square {
  Empty
  Occupied(piece: Piece)
}

// Represents a chess piece with its color and kind.
pub type Piece {
  Piece(color: Color, kind: Kind)
}

// Represents the chess board as a list of 64 squares.
pub type Board =
  List(Square)

// Represents a move from one square to another.
// Coordinates are represented as a tuple of #(column, row),
// where 0-7 represents a-h and 0-7 represents 1-8.
pub type Move {
  Move(from: #(Int, Int), to: #(Int, Int))
}

// Game state to track current player
pub type GameState {
  GameState(board: Board, current_player: Color)
}

// ANSI color codes for terminal colors
pub const white_piece_color = "\u{001b}[97m"

// Bright white
pub const black_piece_color = "\u{001b}[90m"

// Dark gray
pub const reset_color = "\u{001b}[0m"

// Reset

// A helper function to get the Unicode character for a piece with colors
pub fn piece_to_string(square: Square) -> String {
  case square {
    Occupied(piece) -> {
      let symbol = case piece.kind, piece.color {
        Pawn, White -> "♙"
        Pawn, Black -> "♟"
        Rook, White -> "♖"
        Rook, Black -> "♜"
        Knight, White -> "♘"
        Knight, Black -> "♞"
        Bishop, White -> "♗"
        Bishop, Black -> "♝"
        Queen, White -> "♕"
        Queen, Black -> "♛"
        King, White -> "♔"
        King, Black -> "♚"
      }
      let color = case piece.color {
        White -> white_piece_color
        Black -> black_piece_color
      }
      color <> symbol <> reset_color
    }
    Empty -> "·"
  }
}

// Converts a column character ('a' through 'h') to an integer (0-7).
pub fn char_to_column(char: String) -> Result(Int, String) {
  case char {
    "a" -> Ok(0)
    "b" -> Ok(1)
    "c" -> Ok(2)
    "d" -> Ok(3)
    "e" -> Ok(4)
    "f" -> Ok(5)
    "g" -> Ok(6)
    "h" -> Ok(7)
    _ -> Error("Invalid column: " <> char)
  }
}

// Converts a row character ('1' through '8') to an integer (0-7).
pub fn char_to_row(char: String) -> Result(Int, String) {
  case char {
    "1" -> Ok(0)
    "2" -> Ok(1)
    "3" -> Ok(2)
    "4" -> Ok(3)
    "5" -> Ok(4)
    "6" -> Ok(5)
    "7" -> Ok(6)
    "8" -> Ok(7)
    _ -> Error("Invalid row: " <> char)
  }
}

// Convert column index back to letter
pub fn column_to_char(col: Int) -> String {
  case col {
    0 -> "a"
    1 -> "b"
    2 -> "c"
    3 -> "d"
    4 -> "e"
    5 -> "f"
    6 -> "g"
    7 -> "h"
    _ -> "?"
  }
}

// Convert row index back to number
pub fn row_to_char(row: Int) -> String {
  case row {
    0 -> "1"
    1 -> "2"
    2 -> "3"
    3 -> "4"
    4 -> "5"
    5 -> "6"
    6 -> "7"
    7 -> "8"
    _ -> "?"
  }
}
