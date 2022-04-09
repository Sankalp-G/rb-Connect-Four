# board class for connect four
class Board
  attr_reader :board

  def initialize
    @board = create_board
  end

  # creates a 7x6 2d array filled with blank strings
  def create_board
    column = Array.new(6, '')
    arr = Array.new(7, column)
    arr.map(&:clone)
  end

  # checks if the given column number is full or not
  def check_column(num)
    @board[num].include?('')
  end

  # checks if a column is empty if so it adds the coin to the first empty slot
  def drop_coin(coin, column_index)
    raise 'column full cannot drop coin' unless check_column(column_index)

    column = @board[column_index]
    column.each_with_index do |cell, index|
      if cell == ''
        column[index] = coin
        break
      end
    end
    @board[column_index] = column
  end

  # returns element if element occurs 4 or more times consecutively in given array
  # returns false otherwise, blank strings are ignored
  def check_array(array)
    sliced = array.slice_when { |before, after| before != after }

    sliced.each { |arr| return arr[0] if arr.length >= 4 && arr[0] != '' }
    false
  end
end
