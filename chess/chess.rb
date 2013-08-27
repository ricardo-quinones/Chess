require_relative 'board'
require_relative 'piece'
# require_relative 'move_sets_module'

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
    print "\n"
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
    strings = [string[/\D\d/], string[/\D\d$/]]
    move = []
    strings.each do |string|
      pair = []
      string.split("").each do |let_or_num|
        pair << (let_or_num[/\d/] ? let_or_num.to_i - 1 : let_or_num.ord - 97)
      end
      move << pair
    end

    move
  end

end

game = Chess.new
game.play