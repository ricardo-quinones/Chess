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
    else
      return false unless paths_clear?(move, match)
    end

    true
  end

  def paths_clear?(move, match)
    paths = check_paths(move)

    return true if paths.empty?

    paths.each do |row, col|
      unless match[row, col].nil?
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

  def move_set(match)
    pawn_move_set(@position, @color, match)
  end

  def legal?(move, match, turn)
    return false unless move_set(match).include?(move)

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
    p "i'm getting run"
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
    p bishop_move_set(@position)
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