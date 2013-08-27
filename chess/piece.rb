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

  def move_piece(coords, match, turn)
    match[@position[0], @position[1]] = nil
    @position = coords
    match[coords[0], coords[1]] = self
  end

  def legal?(move, match, turn)
    move_set.include?(move) && turn == self.color && paths_clear?(move, match) && self.color != match[move[0], move[1]].color.to_sym
    # return false unless move_set.include?(move)
    # return false unless turn == self.color
    # return false unless paths_clear?(move, match)
    # fix colors && self.color != match[move[0], move[1]].color
    #NEEDS TO CHECK OTHER PIECES
  end

  def paths_clear?(move, match)
    paths = check_paths(move)

    return true if paths.empty?

    paths.each do |row, col|
      return false unless match[row, col].nil?
    end

    true
  end

  def check_paths(move)
    horizontal_path(move)
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

    p spaces_between
    spaces_between
  end

  # def vertical_path(move)
#     row1 = self.position[0]
#     col1 = self.position[1]
#
#     row2 = move[0]
#     col2 = move[1]
#
#     spaces_between = []
#
#     if col1 == col2
#       range = row1 < row2 ? (row1 + 1...row2) : (row2 + 1...row1)
#       range.each do |row|
#         spaces_between << [row, col1]
#       end
#     end
#
#     spaces_between
#   end
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

  def move_set
    pawn_move_set(@position)
  end
end

class Rook < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "♖"
  end

  def move_set
    queen_move_set(@position)
  end
end

class Bishop < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "♗"
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
