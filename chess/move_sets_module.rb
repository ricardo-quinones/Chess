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
    #creating diagonal movement of bishop
    until col - i < 0 && col + i > 7
      move_set << [row + i, col + i] if on_board?([row + i, col + i])
      move_set << [row - i, col - i] if on_board?([row - i, col - i])
      move_set << [row + i, col - i] if on_board?([row + i, col - i])
      move_set << [row - i, col + i] if on_board?([row - i, col + i])

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

  def pawn_move_set(start_pos, color, match)
    row = start_pos[0]
    col = start_pos[1]

    i = (color == :blue ? 1 : -1) # decrease row num if red; increase if blue
    move_set = []
    if match[row + i, col].nil?
      move_set << [row + i, col]

      if match[row + i * 2, col].nil?
        move_set << [row + i * 2, col] if color == :blue && row == 1
        move_set << [row + i * 2, col] if color == :red && row == 6
      end
    end

    move_set + pawn_kill_set(start_pos, color, match)
  end

  #Create separate array of kill moves for pawn to check for 'check' and
  #'checkmate'.
  def pawn_kill_set(start_pos, color, match)
    row = start_pos[0]
    col = start_pos[1]

    i = (color == :blue ? 1 : -1)
    move_set = []

    #Kill move positions
    attack1 = [row + i, col + 1]
    attack2 = [row + i, col - 1]

    #Corresponding spaces of pieces on board during the match
    attack1_target = match[attack1[0], attack1[1]]
    attack2_target = match[attack2[0], attack2[1]]

    #Add kill moves to move_set if position on board if not nil and target piece
    #is a different color.
    move_set << attack1 unless attack1_target.nil? || attack1_target.color == color
    move_set << attack2 unless attack2_target.nil? || attack2_target.color == color

    move_set
  end
end



# p pawn_move_set([1,0], :blue)
