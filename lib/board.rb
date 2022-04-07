# board class for connect four
class Board
  attr_reader :board

  def initialize
    @board = create_board
  end

  # creates a 7x6 2d array filled with blank strings
  def create_board
    collumn = Array.new(6, '')
    Array.new(7, collumn)
  end

  # checks if the given collumn number is full or not
  def check_collumn(num)
    @board[num].include?('')
  end
end
