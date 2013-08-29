require_relative 'board'
require_relative 'piece'
require 'colorize'

class Chess

  attr_accessor :turn

  def initialize
    @match = Board.new
    @turn = :red
  end

  def play
    loop do
      puts @turn == :red ? "\n\nRed, it's your move.".colorize(@turn) : "\n\nBlue, it's your move.".colorize(@turn)
      @match.print_board
      move = get_move
      make_move(move)
      if check?
        puts "\n\nYou're in check, #{@turn.capitalize}!!!".colorize(@turn)

        break if checkmate?
      end
    end

    @match.print_board
    winner = (@turn == :red ? :blue : :red)
    puts "\nCongratulations, #{winner.capitalize} Player. You won!!!".colorize(winner)
  end

  def checkmate?
    king = @match.board.flatten.compact.select do |piece|
      piece.class == King && piece.color == @turn
    end[0]
    king.checkmate?(@match, @turn)
  end

  def check?
    king = @match.board.flatten.compact.select do |piece|
      piece.class == King && piece.color == @turn
    end[0]
    king.check?(@match.board)
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

    if piece.nil?
      puts "That space is empty. Try making another move"
    elsif piece.legal?(move[1], @match, @turn) && !piece.self_check?(move[1], @match, @turn)
      piece.move_piece(move[1], @match)

      @turn = (@turn == :red ? :blue : :red)
    else

      puts "Invalid move. Try making another move."
    end
  end

  def parse_position(string)
    # Possible parsing error
    strings = [string[/\D\d/], string[/\D\d$/]]
    move = []
    strings.each do |string|
      pair = []
      string.split("").each do |let_or_num|
        pair << (let_or_num[/\d/] ? -(let_or_num.to_i - 8) : let_or_num.ord - 97)
      end
      move << pair.reverse #ducktape; reversed pair because of rendering
    end

    move
  end
end

game = Chess.new
game.play
