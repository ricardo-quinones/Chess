class Board

  attr_accessor :board

  def initialize
    @board = make_board
    set_board
    print_board
  end

  def set_board
    colors = [:white, :black]
    # White
    @board[0][0] = Rook.new(:white)
    @board[0][1] = Knight.new(:white)
    @board[0][2] = Bishop.new(:white)
    @board[0][3] = Queen.new(:white)
    @board[0][4] = King.new(:white)
    @board[0][5] = Bishop.new(:white)
    @board[0][6] = Knight.new(:white)
    @board[0][7] = Rook.new(:white)

    (0..7).each { |y| @board[1][y] = Pawn.new(:white) }
    # Black
    @board[7][0] = Rook.new(:black)
    @board[7][1] = Knight.new(:black)
    @board[7][2] = Bishop.new(:black)
    @board[7][3] = Queen.new(:black)
    @board[7][4] = King.new(:black)
    @board[7][5] = Bishop.new(:black)
    @board[7][6] = Knight.new(:black)
    @board[7][7] = Rook.new(:black)

    (0..7).each { |y| @board[6][y] = Pawn.new(:black) }

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
    print " "
    ("A".."H").each { |letter| print letter.center(3, " ") }
    print "\n"
    @board.each_with_index do |row, index|
      print "#{index + 1}"
      row.each do |position|
        print position ? " #{position.symbol} " : " * "
      end
      print "#{index + 1}\n"
    end
    print " "
    ("A".."H").each { |letter| print letter.center(3, " ") }
  end

end