# board class for connect four
class Board
  attr_reader :board

  def initialize
    @board = create_board
  end

  # creates a 7x6 2d array filled with blank strings
  def create_board
    collumn = Array.new(6, '')
    arr = Array.new(7, collumn)
    arr.map(&:clone)
  end

  # checks if the given collumn number is full or not
  def check_collumn(num)
    @board[num].include?('')
  end

  # checks if a collumn is empty if so it adds the coin to the first empty slot
  def drop_coin(coin, collumn_index)
    raise 'Collumn full cannot drop coin' unless check_collumn(collumn_index)

    collumn = @board[collumn_index]
    collumn.each_with_index do |cell, index|
      if cell == ''
        collumn[index] = coin
        break
      end
    end
    @board[collumn_index] = collumn
  end
end
