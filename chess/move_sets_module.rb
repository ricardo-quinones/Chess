module MoveSets

  def on_board?(coords)
    coords[0].between?(0, 7) && coords[1].between?(0, 7)
  end

  def rook_move_set(start_pos)
    move_set = []

    row = start_pos[0]
    col = start_pos[1]

    i = 1
    #creating vertical movement of rook
    until col - i < 0 && col + i > 7
      move_set << [row, col - i] if on_board?([row, col - i])
      move_set << [row, col + i] if on_board?([row, col + i])
      i += 1
    end

    i = 1
    #creating horizontal movement of rook
    until row - i < 0 && row + i > 7
      move_set << [row - i, col] if on_board?([row - i, col])
      move_set << [row + i, col] if on_board?([row + i, col])
      i += 1
    end

    move_set
  end

  def bishop_move_set(start_pos)
    move_set = []

    row = start_pos[0]
    col = start_pos[1]

    i = 1
    #creating vertical movement of rook
    until col - i < 0 && col + i > 7
      move_set << [row + i, col + 1] if on_board?([row + i, col + 1])
      move_set << [row - i, col - 1] if on_board?([row - i, col - 1])
      move_set << [row + i, col - 1] if on_board?([row + i, col - 1])
      move_set << [row - i, col + 1] if on_board?([row - i, col + 1])

      i += 1
    end

    move_set
  end

  def queen_move_set(start_pos)
    bishop_move_set(start_pos) + rook_move_set(start_pos)
  end

  def king_move_set(start_pos)
    move_set = []
    row = start_pos[0]
    col = start_pos[1]
    (row - 1..row + 1).each do |x|
      (col - 1..col + 1).each do |y|
        next if x == row && y == col
        move_set << [x, y] if on_board?([x, y])
      end
    end

    move_set
  end

  def knight_move_set(start_pos)
    move_set = []

    row = start_pos[0]
    col = start_pos[1]

    knight_moves =  [[1,2],[-1,-2],[-1,2],[2,-1],[-2,-1],[2,1],[1,-2],[-2,1]]
    knight_moves.each do |pos|
      move_set << [row + pos[0], col + pos[1]] if on_board?([row + pos[0], col + pos[1]])
    end

    move_set
  end

  def pawn_move_set(start_pos)
    row = start_pos[0]
    col = start_pos[1]

    [[row - 1, col], [row + 1, col], [row - 2, col], [row + 2, col],
    [row + 1, col + 1], [row + 1, col - 1], [row - 1, col + 1],
    [row - 1, col - 1]].select { |move| on_board?(move) }
  end
end



# p pawn_move_set([5,5])