// src/main.gleam
import chess_board as board
import chess_input as input
import chess_moves as moves
import chess_parser as parser
import chess_types as types
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  let initial_state = types.GameState(board.initial_board(), types.White)
  io.println("Welcome to Terminal Chess!")
  io.println("Enter moves in format: e2->e4")
  io.println("Enter just a position (e.g., 'e2') to see possible moves")
  io.println("Enter 'quit' to exit")
  io.println("")

  game_loop(initial_state)
}

fn game_loop(state: types.GameState) {
  let types.GameState(current_board, current_player) = state

  // Print current board
  board.print_board(current_board)
  io.println("")

  // Show current player
  let player_name = case current_player {
    types.White -> "White"
    types.Black -> "Black"
  }
  let colored_player = case current_player {
    types.White -> types.white_piece_color <> player_name <> types.reset_color
    types.Black -> types.black_piece_color <> player_name <> types.reset_color
  }
  io.println("Current player: " <> colored_player)

  // Get user input
  case input.get_user_input("Enter move: ") {
    "quit" -> {
      io.println("Thanks for playing!")
      Nil
    }
    input -> {
      handle_input(state, input)
    }
  }
}

fn handle_input(state: types.GameState, input: String) {
  let types.GameState(current_board, current_player) = state

  case string.contains(input, "->") {
    True -> {
      // Full move format
      case parser.parse_move(input) {
        Ok(move) -> {
          case moves.is_valid_move(current_board, move, current_player) {
            True -> {
              case board.make_move(current_board, move) {
                Ok(new_board) -> {
                  let next_player = case current_player {
                    types.White -> types.Black
                    types.Black -> types.White
                  }
                  io.println("Move successful!")
                  io.println("")
                  game_loop(types.GameState(new_board, next_player))
                }
                Error(e) -> {
                  io.println("Error making move: " <> e)
                  game_loop(state)
                }
              }
            }
            False -> {
              io.println("Invalid move!")
              game_loop(state)
            }
          }
        }
        Error(e) -> {
          io.println("Error parsing move: " <> e)
          game_loop(state)
        }
      }
    }
    False -> {
      // Single coordinate - show possible moves
      case parser.parse_coordinate_only(input) {
        Ok(coord) -> {
          // Debug: show what piece is at this coordinate
          case board.get_square(current_board, coord) {
            Ok(types.Occupied(piece)) -> {
              let color_name = case piece.color {
                types.White -> "White"
                types.Black -> "Black"
              }
              let kind_name = case piece.kind {
                types.Pawn -> "Pawn"
                types.Rook -> "Rook"
                types.Knight -> "Knight"
                types.Bishop -> "Bishop"
                types.Queen -> "Queen"
                types.King -> "King"
              }
              io.println(
                "Found "
                <> color_name
                <> " "
                <> kind_name
                <> " at "
                <> parser.format_coordinate(coord),
              )
            }
            Ok(types.Empty) ->
              io.println("Empty square at " <> parser.format_coordinate(coord))
            Error(e) -> io.println("Error: " <> e)
          }

          let possible_moves =
            moves.get_valid_moves(current_board, coord, current_player)
          case list.length(possible_moves) {
            0 -> {
              io.println(
                "No valid moves from " <> parser.format_coordinate(coord),
              )
              game_loop(state)
            }
            _ -> {
              io.println(
                "Possible moves from " <> parser.format_coordinate(coord) <> ":",
              )
              list.each(possible_moves, fn(to_coord) {
                io.println(
                  "  "
                  <> parser.format_coordinate(coord)
                  <> "->"
                  <> parser.format_coordinate(to_coord),
                )
              })
              io.println("")
              game_loop(state)
            }
          }
        }
        Error(e) -> {
          io.println("Error parsing coordinate: " <> e)
          game_loop(state)
        }
      }
    }
  }
}
