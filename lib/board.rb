# board class for connect four
class Board
  # creates a 7x6 2d array filled with blank strings
  def create_board
    collumn = Array.new(6, '')
    Array.new(7, collumn)
  end
end
