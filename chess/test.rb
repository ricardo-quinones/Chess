def diagonal_path(start, move)
  row1 = start[0]
  col1 = start[1]

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

p diagonal_path([0,8],[8,0])