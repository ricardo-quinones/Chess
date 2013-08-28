# encoding: UTF-8
require_relative 'move_sets_module'

class Piece

  include MoveSets

  attr_reader :color, :symbol
  attr_accessor :position

  def initialize(color)
    @color = color
    @position = nil
    @symbol = nil
  end

  def move_piece(coords, match)
    match[@position[0], @position[1]] = nil
    @position = coords
    match[coords[0], coords[1]] = self
  end

  def legal?(move, match, turn)
    row = move[0]
    col = move[1]

    if turn != self.color
      puts "Sorry, that piece is not yours to move."
      return false
    elsif !match[row, col].nil? && self.color == match[row, col].color.to_sym
      puts "Whoa! You don't want to capture your own piece!"
      return false
    elsif self.class != Pawn && !move_set.include?(move)
      puts "That piece cannot move in that way."
      return false
    elsif !paths_clear?(move, match.board)
      return false
    else
      return false if self_check?(move, match, turn)
    end

    true
  end

  def self_check?(move, match, turn)
    temp_board = match.board.deep_dup

    temp_board[@position[0]][@position[1]] = nil
    temp_board[move[0]][move[1]] = self.dup

    king = temp_board.flatten.compact.select do |piece|
      piece.class == King && piece.color == turn
    end[0]

    king.position = [move[0], move[1]] if self.class == King

    opponent_pieces = temp_board.flatten.compact.select { |piece| piece.color != self.color }

    other_pieces = opponent_pieces.any? do |piece|

      piece.move_set.include?(king.position) unless piece.class == Pawn
    end
    pawn_pieces = opponent_pieces.any? do |piece|
      piece.move_set(temp_board).include?(king.position) if piece.class == Pawn
    end
    puts "You can't put your king in check!" if other_pieces || pawn_pieces
    other_pieces || pawn_pieces
  end

  def paths_clear?(move, board)
    paths = check_paths(move)

    return true if paths.empty?

    paths.each do |row, col|
      unless board[row][col].nil?
        puts "There are pieces in the way."
        return false
      end
    end

    true
  end

  def check_paths(move)
    []
  end

  def horizontal_path(move)
    row1 = self.position[0]
    col1 = self.position[1]

    row2 = move[0]
    col2 = move[1]

    spaces_between = []

    if row1 == row2
      range = col1 < col2 ? (col1 + 1...col2) : (col2 + 1...col1)
      range.each do |col|
        spaces_between << [row1, col]
      end
    end

    spaces_between
  end

  def vertical_path(move)
    row1 = self.position[0]
    col1 = self.position[1]

    row2 = move[0]
    col2 = move[1]

    spaces_between = []

    if col1 == col2
      range = row1 < row2 ? (row1 + 1...row2) : (row2 + 1...row1)
      range.each do |row|
        spaces_between << [row, col1]
      end
    end

    spaces_between
  end

  def diagonal_path(move)
    row1 = self.position[0]
    col1 = self.position[1]

    row2 = move[0]
    col2 = move[1]

    spaces_between = []

    row_array = (row1 < row2 ? (row1 + 1...row2) : (row2 + 1...row1)).to_a
    col_array = (col1 < col2 ? (col1 + 1...col2) : (col2 + 1...col1)).to_a

    if (row1 > row2 && col1 < col2) || (row1 < row2 && col1 > col2)
      col_array.reverse!
    end

    row_array.count.times do |index|
      spaces_between << [row_array[index], col_array[index]]
    end

    spaces_between
  end
end

class King < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "♚"
  end

  def move_set
    king_move_set(@position)
  end

  def check?(board)
    opponent_pieces = board.flatten.compact.select { |piece| piece.color != self.color }

    other_pieces = opponent_pieces.any? do |piece|
      piece.move_set.include?(self.position) unless piece.class == Pawn
    end
    pawn_pieces = opponent_pieces.any? do |piece|
      piece.move_set(board).include?(self.position) if piece.class == Pawn
    end
    puts "king is in check" if other_pieces || pawn_pieces
    other_pieces || pawn_pieces
  end
end

class Queen < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "♛"
  end

  def check_paths(move)
    super + horizontal_path(move) + vertical_path(move) + diagonal_path(move)
  end

  def move_set
    queen_move_set(@position)
  end

end

class Pawn < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "♙"
  end

  def move_set(board)
    pawn_move_set(@position, @color, board)
  end

  def legal?(move, match, turn)
    return false unless move_set(match.board).include?(move)

    super
  end
end

class Rook < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "♖"
  end

  def move_set
    rook_move_set(@position)
  end

  def check_paths(move)
    super + horizontal_path(move) + vertical_path(move)
  end
end

class Bishop < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "♗"
  end

  def check_paths(move)
    super + diagonal_path(move)
  end

  def move_set
    bishop_move_set(@position)
  end
end

class Knight < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "♘"
  end

  def move_set
    knight_move_set(@position)
  end
end

def print_board(dup_board)
  print "\n DUPLICATE BOARD"
  ("A".."H").each { |letter| print letter.center(3, " ") }
  print "\n"
  dup_board.each_with_index do |row, index|
    print "#{8 - index}"
    row.each do |piece|
      print piece ? " #{piece.symbol.colorize(piece.color)} " : " _ "
    end
    print "#{8 - index}\n"
  end
  print " "
  ("A".."H").each { |letter| print letter.center(3, " ") }
end

class Array

  def deep_dup
    self.map { |elem| elem.is_a?(Array) ? elem.deep_dup : elem }
  end

end