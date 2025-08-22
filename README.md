# chess_gleam

A fun, little command-line chess game built with the Gleam programming language.

# Preview
<img width="464" height="881" alt="image" src="https://github.com/user-attachments/assets/e2cb9418-8967-4c6f-969f-01e5d95c0d05" />

## Features

* **Interactive Command-Line Interface:** Play chess directly in your terminal.
* **Full Board Visualization:** Displays the board using Unicode chess pieces.
* **Basic Move Validation:** Enforces the legal moves for all chess pieces.
* **Player Turns:** Manages turns between White and Black players.
* **Move Suggestions:** Enter a square coordinate (e.g., `e2`) to see all possible moves for the piece on that square.

## How to Play

1.  Make sure you have Gleam installed.
2.  Clone this repository.
3.  Run the game with the following command:
    ```sh
    gleam run
    ```
4.  Follow the on-screen instructions to enter your moves in the format `from->to` (e.g., `e2->e4`).

## Development

To run the project locally:

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
