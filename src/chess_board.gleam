// src/chess_board.gleam
import chess_types as types
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

// Initializes the board with all the pieces in their starting positions.
pub fn initial_board() -> types.Board {
  let white_back_row = [
    types.Occupied(types.Piece(types.White, types.Rook)),
    types.Occupied(types.Piece(types.White, types.Knight)),
    types.Occupied(types.Piece(types.White, types.Bishop)),
    types.Occupied(types.Piece(types.White, types.Queen)),
    types.Occupied(types.Piece(types.White, types.King)),
    types.Occupied(types.Piece(types.White, types.Bishop)),
    types.Occupied(types.Piece(types.White, types.Knight)),
    types.Occupied(types.Piece(types.White, types.Rook)),
  ]
  let white_pawns =
    list.repeat(types.Occupied(types.Piece(types.White, types.Pawn)), 8)
  let empty_rows = list.repeat(types.Empty, 32)
  let black_pawns =
    list.repeat(types.Occupied(types.Piece(types.Black, types.Pawn)), 8)
  let black_back_row = [
    types.Occupied(types.Piece(types.Black, types.Rook)),
    types.Occupied(types.Piece(types.Black, types.Knight)),
    types.Occupied(types.Piece(types.Black, types.Bishop)),
    types.Occupied(types.Piece(types.Black, types.Queen)),
    types.Occupied(types.Piece(types.Black, types.King)),
    types.Occupied(types.Piece(types.Black, types.Bishop)),
    types.Occupied(types.Piece(types.Black, types.Knight)),
    types.Occupied(types.Piece(types.Black, types.Rook)),
  ]

  list.append(white_back_row, white_pawns)
  |> list.append(empty_rows)
  |> list.append(black_pawns)
  |> list.append(black_back_row)
}

// Prints the current state of the board to the terminal.
pub fn print_board(board: types.Board) {
  io.println("  a b c d e f g h")
  board
  |> list.sized_chunk(8)
  |> list.reverse()
  |> list.index_map(fn(row, index) {
    let row_number = 8 - index
    let row_string =
      row
      |> list.map(types.piece_to_string)
      |> string.join(" ")
    io.println(int.to_string(row_number) <> " " <> row_string)
  })
}

// Convert 2D coordinates to 1D index
pub fn coord_to_index(coord: #(Int, Int)) -> Int {
  let #(col, row) = coord
  row * 8 + col
}

// Convert 1D index to 2D coordinates
pub fn index_to_coord(index: Int) -> #(Int, Int) {
  #(index % 8, index / 8)
}

// Get the piece at a given coordinate
pub fn get_square(
  board: types.Board,
  coord: #(Int, Int),
) -> Result(types.Square, String) {
  let index = coord_to_index(coord)
  case index >= 0 && index < 64 {
    True -> {
      let squares = list.drop(board, index)
      case squares {
        [square, ..] -> Ok(square)
        [] -> Error("Invalid coordinate")
      }
    }
    False -> Error("Invalid coordinate")
  }
}

// Set a square at a given coordinate
pub fn set_square(
  board: types.Board,
  coord: #(Int, Int),
  square: types.Square,
) -> Result(types.Board, String) {
  let index = coord_to_index(coord)
  case index >= 0 && index < 64 {
    True -> {
      let before = list.take(board, index)
      let after = list.drop(board, index + 1)
      Ok(list.append(before, [square, ..after]))
    }
    False -> Error("Invalid coordinate")
  }
}

// Make a move on the board
pub fn make_move(
  board: types.Board,
  move: types.Move,
) -> Result(types.Board, String) {
  let types.Move(from, to) = move

  use from_square <- result.try(get_square(board, from))
  use _to_square <- result.try(get_square(board, to))

  case from_square {
    types.Empty -> Error("No piece at source position")
    types.Occupied(piece) -> {
      use board_after_clear <- result.try(set_square(board, from, types.Empty))
      set_square(board_after_clear, to, types.Occupied(piece))
    }
  }
}

// Check if coordinates are valid
pub fn valid_coord(coord: #(Int, Int)) -> Bool {
  let #(col, row) = coord
  col >= 0 && col < 8 && row >= 0 && row < 8
}
