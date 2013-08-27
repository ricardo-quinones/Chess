class Board

  attr_accessor :board

  def initialize
    @board = make_board
    set_board
    print_board
  end

  def set_board
    @board[0][4] = King.new
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