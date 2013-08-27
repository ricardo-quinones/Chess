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

  def set_piece(row, col, board)
    board[row, col] = self
  end

  def move_piece(coords, board)
    if legal?(coords)
      p move_set.include?(coords)
      board[@position[0], @position[1]] = nil
      @position = coords
      board[coords[0], coords[1]] = self
    else
      puts "That's not a legal move"
    end
  end

  def legal?(move)
    move_set.include?(move)
  end


end

class King < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "K"
  end

  def move_set
    king_move_set(@position)
  end

end

class Queen < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "Q"
  end

  def move_set
    queen_move_set(@position)
  end
end

class Pawn < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "i"
  end

  def move_set
    pawn_move_set(@position)
  end
end

class Rook < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "R"
  end

  def move_set
    queen_move_set(@position)
  end
end

class Bishop < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "B"
  end

  def move_set
    bishop_move_set(@position)
  end
end

class Knight < Piece

  attr_reader :move_set

  def initialize(color)
    super
    @symbol = "k"
  end

  def move_set
    knight_move_set(@position)
  end
end
