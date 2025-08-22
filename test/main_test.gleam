import chess_board as board
import chess_moves as moves
import chess_types as types
import gleam/io

// A single test function
pub fn test_initial_pawn_move() {
  let initial_board = board.initial_board()
  let pawn_move = types.Move(#(4, 1), #(4, 3))
  // e2 to e4
  let is_valid = moves.is_valid_move(initial_board, pawn_move, types.White)

  case is_valid {
    True -> io.println("Test passed: e2 to e4 is a valid move.")
    False -> panic as "Test failed: e2 to e4 should be a valid move."
  }
}

// The main function that the test runner executes
pub fn main() {
  io.println("Running tests...")
  test_initial_pawn_move()
  io.println("All tests passed!")
}
