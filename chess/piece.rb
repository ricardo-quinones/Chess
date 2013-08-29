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
      return false
    elsif !match[row, col].nil? && self.color == match[row, col].color.to_sym
      return false
    elsif self.class != Pawn && !move_set.include?(move)
      return false
    elsif !paths_clear?(move, match.board)
      return false
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

    king.check?(temp_board)
  end

  def checkmate?(match, turn)
    checkmate = true
    my_pieces = match.board.dup.flatten.compact.select { |piece| piece.color == self.color }

    my_pieces.each do |piece|
      temp_board = match.board.deep_dup

      next if piece.class == King
      moves = (piece.class == Pawn ? piece.move_set(temp_board) : piece.move_set)
      moves.each do |move|
        next unless piece.legal?(move, match, turn)

        row = piece.position[0]
        col = piece.position[1]

        temp_board[row][col] = nil
        temp_board[move[0]][move[1]] = piece.dup

        checkmate = false unless self.check?(temp_board)
      end
    end

    # define checkmate for when king tries to move out of it
    self.move_set.each do |move|
      next unless self.legal?(move, match, turn)

      temp_board = match.board.deep_dup
      temp_king = self.dup

      row = self.position[0]
      col = self.position[1]

      temp_board[row][col] = nil
      temp_king.position = [move[0], move[1]]

      checkmate = false unless temp_king.check?(temp_board)
    end

    checkmate
  end

  def paths_clear?(move, board)
    paths = check_paths(move)

    return true if paths.empty?

    paths.each do |row, col|
      unless board[row][col].nil?
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
      unless piece.class == Pawn
        piece.move_set.include?(self.position) && piece.paths_clear?(self.position, board)
      end
    end
    pawn_pieces = opponent_pieces.any? do |piece|
      piece.move_set(board).include?(self.position) if piece.class == Pawn
    end

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

class Array
  def deep_dup
    self.map { |elem| elem.is_a?(Array) ? elem.deep_dup : elem }
  end
end