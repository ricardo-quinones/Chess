require_relative 'move_set_module'

class Piece

  include MoveSets

  attr_accessor :color, :position, :symbol

  def initialize
    @color = nil
    @position = nil
    @symbol = nil
  end

  def set_piece(row, col, board)
    board[row, col] = self
  end

  def move_piece(coords, board)
    board[@position[0], @position[1]] = nil
    @position = coords
    board[coords[0], coords[1]] = self
  end

  def legal?(move)
    move_set.include?(move)
  end

end




class King < Piece

  def initialize
    super
    @symbol = "K"
    @position = [0, 4]
    @move_set = king_move_set(@position)
  end

end

class Queen < Piece

end

class Pawn < Piece

end
