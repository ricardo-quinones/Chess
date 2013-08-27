require_relative 'board'
require_relative 'piece'

class Chess

  def initialize
    @match = Board.new
  end

  def play
    while true
      @match.print_board
      move = get_move
      make_move(move)
    end
  end

  def get_move
    puts "Position: "
    start_pos = parse_position(gets.chomp)
    puts "Move to"
    end_pos = parse_position(gets.chomp)
    move = [start_pos, end_pos]
  end

  def make_move(move)
    start_x, start_y = move[0][0], move[0][1]
    end_x, end_y = move[1][0], move[1][1]
    piece = @match.board[start_x][start_y]
    piece.move_piece(move[1], @match)
  end

  def parse_position(string)
    string.split(" ").map { |coord| coord.to_i }
  end

end

game = Chess.new
game.play