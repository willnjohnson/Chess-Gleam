// src/chess_moves.gleam
import chess_board as board
import chess_types as types
import gleam/list

// Check if a move is valid (basic validation)
pub fn is_valid_move(
  board_state: types.Board,
  move: types.Move,
  player: types.Color,
) -> Bool {
  let types.Move(from, to) = move

  // Check if coordinates are valid
  case board.valid_coord(from) && board.valid_coord(to) {
    False -> False
    True -> {
      case
        board.get_square(board_state, from),
        board.get_square(board_state, to)
      {
        Ok(types.Occupied(piece)), Ok(to_square) -> {
          // Check if piece belongs to current player
          case piece.color == player {
            False -> False
            True -> {
              // Check if destination is not occupied by same color
              case to_square {
                types.Occupied(target_piece) -> target_piece.color != player
                types.Empty -> True
              }
              && is_valid_piece_move(board_state, piece, from, to)
            }
          }
        }
        _, _ -> False
      }
    }
  }
}

// Check if a piece can legally move from one position to another
fn is_valid_piece_move(
  board_state: types.Board,
  piece: types.Piece,
  from: #(Int, Int),
  to: #(Int, Int),
) -> Bool {
  let #(from_col, from_row) = from
  let #(to_col, to_row) = to
  let col_diff = to_col - from_col
  let row_diff = to_row - from_row

  case piece.kind {
    types.Pawn ->
      is_valid_pawn_move(board_state, piece.color, from, to, col_diff, row_diff)
    types.Rook -> is_valid_rook_move(board_state, from, to, col_diff, row_diff)
    types.Knight -> is_valid_knight_move(col_diff, row_diff)
    types.Bishop ->
      is_valid_bishop_move(board_state, from, to, col_diff, row_diff)
    types.Queen ->
      is_valid_queen_move(board_state, from, to, col_diff, row_diff)
    types.King -> is_valid_king_move(col_diff, row_diff)
  }
}

fn is_valid_pawn_move(
  board_state: types.Board,
  color: types.Color,
  from: #(Int, Int),
  to: #(Int, Int),
  col_diff: Int,
  row_diff: Int,
) -> Bool {
  let #(from_col, from_row) = from
  let direction = case color {
    types.White -> 1
    // White moves up
    types.Black -> -1
    // Black moves down
  }
  let starting_row = case color {
    types.White -> 1
    types.Black -> 6
  }

  case board.get_square(board_state, to) {
    Ok(types.Occupied(_)) -> {
      // Diagonal capture
      int_abs(col_diff) == 1 && row_diff == direction
    }
    Ok(types.Empty) -> {
      // Forward move
      case col_diff, row_diff {
        0, diff if diff == direction -> True
        // Double forward move from starting position
        0, diff if diff == direction * 2 && from_row == starting_row -> {
          let middle_square_coord = #(from_col, from_row + direction)
          case board.get_square(board_state, middle_square_coord) {
            Ok(types.Empty) -> True
            _ -> False
          }
        }
        _, _ -> False
      }
    }
    _ -> False
  }
}

fn is_valid_rook_move(
  board_state: types.Board,
  from: #(Int, Int),
  to: #(Int, Int),
  col_diff: Int,
  row_diff: Int,
) -> Bool {
  case col_diff == 0 || row_diff == 0 {
    True -> is_path_clear(board_state, from, to)
    False -> False
  }
}

fn is_valid_knight_move(col_diff: Int, row_diff: Int) -> Bool {
  case col_diff, row_diff {
    2, 1 | 2, -1 | -2, 1 | -2, -1 | 1, 2 | 1, -2 | -1, 2 | -1, -2 -> True
    _, _ -> False
  }
}

fn is_valid_bishop_move(
  board_state: types.Board,
  from: #(Int, Int),
  to: #(Int, Int),
  col_diff: Int,
  row_diff: Int,
) -> Bool {
  case int_abs(col_diff) == int_abs(row_diff) && col_diff != 0 {
    True -> is_path_clear(board_state, from, to)
    False -> False
  }
}

fn is_valid_queen_move(
  board_state: types.Board,
  from: #(Int, Int),
  to: #(Int, Int),
  col_diff: Int,
  row_diff: Int,
) -> Bool {
  is_valid_rook_move(board_state, from, to, col_diff, row_diff)
  || is_valid_bishop_move(board_state, from, to, col_diff, row_diff)
}

fn is_valid_king_move(col_diff: Int, row_diff: Int) -> Bool {
  int_abs(col_diff) <= 1
  && int_abs(row_diff) <= 1
  && { col_diff != 0 || row_diff != 0 }
}

// Helper function for absolute value
fn int_abs(n: Int) -> Int {
  case n < 0 {
    True -> -n
    False -> n
  }
}

// Check if the path between two squares is clear
fn is_path_clear(
  board_state: types.Board,
  from: #(Int, Int),
  to: #(Int, Int),
) -> Bool {
  let #(from_col, from_row) = from
  let #(to_col, to_row) = to
  let col_step = case to_col - from_col {
    0 -> 0
    diff if diff > 0 -> 1
    _ -> -1
  }
  let row_step = case to_row - from_row {
    0 -> 0
    diff if diff > 0 -> 1
    _ -> -1
  }

  check_path_recursive(
    board_state,
    from_col + col_step,
    from_row + row_step,
    to_col,
    to_row,
    col_step,
    row_step,
  )
}

fn check_path_recursive(
  board_state: types.Board,
  col: Int,
  row: Int,
  to_col: Int,
  to_row: Int,
  col_step: Int,
  row_step: Int,
) -> Bool {
  case col == to_col && row == to_row {
    True -> True
    // Reached destination
    False -> {
      case board.get_square(board_state, #(col, row)) {
        Ok(types.Empty) ->
          check_path_recursive(
            board_state,
            col + col_step,
            row + row_step,
            to_col,
            to_row,
            col_step,
            row_step,
          )
        _ -> False
        // Path blocked
      }
    }
  }
}

// Get all valid moves for a piece at a given position
pub fn get_valid_moves(
  board_state: types.Board,
  from: #(Int, Int),
  player: types.Color,
) -> List(#(Int, Int)) {
  case board.get_square(board_state, from) {
    Ok(types.Occupied(piece)) if piece.color == player -> {
      list.range(0, 7)
      |> list.flat_map(fn(row) {
        list.range(0, 7)
        |> list.map(fn(col) { #(col, row) })
      })
      |> list.filter(fn(to) {
        is_valid_move(board_state, types.Move(from, to), player)
      })
    }
    _ -> []
  }
}
