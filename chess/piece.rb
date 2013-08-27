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
    move_set.include?(move) && turn == self.color
    #NEEDS TO CHECK OTHER PIECES
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
