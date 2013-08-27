require_relative 'board'
require_relative 'piece'

class Chess

  attr_accessor :turn


  def initialize
    @match = Board.new
    @turn = :red
  end

  def play
    while true
      puts @turn == :red ? "\n\nRed, it's your move." : "\n\nBlue, it's your move."
      @match.print_board
      move = get_move
      make_move(move)
    end
  end

  def get_move
    print "\n"
    puts "Enter Initial and End Position"
    parse_position(gets.chomp.strip.downcase)
  end

  def make_move(move)
    start_x, start_y = move[0][0], move[0][1]
    end_x, end_y = move[1][0], move[1][1]

    piece = @match.board[start_x][start_y]

    if piece.legal?(move[1], @match, @turn)
      piece.move_piece(move[1], @match, @turn)

      @turn = (@turn == :red ? :blue : :red)
    else

      puts "That's not a legal move"
    end
  end

  def parse_position(string)
    # Possible parsing error

    strings = [string[/\D\d/], string[/\D\d$/]]
    move = []
    strings.each do |string|
      pair = []
      string.split("").each do |let_or_num|
        pair << (let_or_num[/\d/] ? let_or_num.to_i - 1 : let_or_num.ord - 97)
      end
      move << pair.reverse #ducktape; reversed pair because of rendering
    end

    move
  end

end

game = Chess.new
game.play