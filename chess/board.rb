require 'colorize'

class Board

  attr_accessor :board

  def initialize
    @board = make_board
    set_board
  end

  def set_board
    # Red
    @board[7][0] = Rook.new(:red)
    @board[7][1] = Knight.new(:red)
    @board[7][2] = Bishop.new(:red)
    @board[7][3] = Queen.new(:red)
    @board[7][4] = King.new(:red)
    @board[7][5] = Bishop.new(:red)
    @board[7][6] = Knight.new(:red)
    @board[7][7] = Rook.new(:red)

    (0..7).each { |y| @board[6][y] = Pawn.new(:red) }
    # Blue
    @board[0][0] = Rook.new(:blue)
    @board[0][1] = Knight.new(:blue)
    @board[0][2] = Bishop.new(:blue)
    @board[0][3] = Queen.new(:blue)
    @board[0][4] = King.new(:blue)
    @board[0][5] = Bishop.new(:blue)
    @board[0][6] = Knight.new(:blue)
    @board[0][7] = Rook.new(:blue)

    (0..7).each { |y| @board[1][y] = Pawn.new(:blue) }

    @board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        piece.position = [i, j] unless piece.nil?
      end
    end
  end

  def []=(x, y, value)
    @board[x][y] = value
  end

  def [](x, y)
    @board[x][y]
  end

  def make_board
    board = Array.new(8) { Array.new(8)}
  end

  def print_board
    print "\n "
    ("A".."H").each { |letter| print letter.center(3, " ") }
    print "\n"
    @board.each_with_index do |row, index|
      print "#{8 - index}"
      row.each do |piece|
        print piece ? " #{piece.symbol.colorize(piece.color)} " : " _ "
      end
      print "#{8 - index}\n"
    end
    print " "
    ("A".."H").each { |letter| print letter.center(3, " ") }
  end
end