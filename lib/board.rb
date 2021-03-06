require 'colorize'

# board class for connect four
class Board
  attr_reader :board
  attr_accessor :coin

  def initialize
    @board = create_board
    @coin = '⬤'
    @enable_index_row = true
  end

  # creates a 7x6 2d array filled with blank strings
  def create_board
    column = Array.new(6, '')
    arr = Array.new(7, column)
    arr.map(&:clone)
  end

  def clear_board
    @board = create_board
  end

  # prints out an example board
  def display_example_board
    example_board = clone
    example_board.clear_board
    6.times { example_board.drop_coin('blue', 2) }
    6.times { example_board.drop_coin('red', 4) }
    example_board.display_board
  end

  # checks if the given column number is full or not, true if full
  def column_full?(num)
    not_full = @board[num].include?('')
    !not_full
  end

  # checks if a column is empty if so it adds the coin to the first empty slot
  def drop_coin(coin, column_index)
    raise 'column full cannot drop coin' if column_full?(column_index)

    column = @board[column_index]
    column.each_with_index do |cell, index|
      if cell == ''
        column[index] = coin
        break
      end
    end
    @board[column_index] = column
  end

  # returns element if it occurs consecutively 4 or more times in the entire board else returns false
  def win_condition
    return consecutive_in_columns? if consecutive_in_columns?
    return consecutive_in_rows? if consecutive_in_rows?
    return consecutive_in_diagonals? if consecutive_in_diagonals?
    return 'tie' if tie?

    false
  end

  # prints the board with colored coins, separated by '|'
  def display_board
    board = grab_rows.reverse
    separator = '|'.colorize(color: :white, background: :black)
    board.each do |row|
      print separator
      row.each { |coin| print color_coin(coin), separator }
      puts
    end
    print_index_row if @enable_index_row
  end

  def print_index_row
    separator = '|'.colorize(color: :white, background: :black)
    7.times { |i| print separator, (i + 1) }
    print separator, "\n"
  end

  def toggle_index_row
    @enable_index_row = !@enable_index_row
  end

  # returns rows converted from @board
  def grab_rows
    rows = Array.new(6) { [] }
    @board.each do |column|
      column.each_with_index do |element, row_index|
        rows[row_index].push(element)
      end
    end
    rows
  end

  # returns all diagonals of the board not just the main two, raises error if columns aren't of equal length
  def grab_diagonals
    raise 'columns must be of equal length' unless @board.all? { |column| @board[0].length == column.length }

    padding = Array.new(@board.length - 1, nil)
    padded_board = @board.map { |column| padding + column + padding }
    process_padded_board(padded_board)
  end

  # returns element if element occurs 4 or more times consecutively in given array
  # returns false otherwise, blank strings are ignored
  def contains_consecutive?(array)
    sliced = array.slice_when { |before, after| before != after }

    sliced.each { |arr| return arr[0] if arr.length >= 4 && arr[0] != '' }
    false
  end

  # checks for consecutive in all sub arrays returns element if found, else returns false
  def check_for_consecutive_in(array_2d)
    array_2d.each { |array| return contains_consecutive?(array) if contains_consecutive?(array) }
    false
  end

  ### start of private methods
  private

  # takes a padded board and returns all diagonal elements with nil values removed
  def process_padded_board(padded_board)
    reversed_board = padded_board.reverse
    diagonals = padded_diagonals(padded_board) + padded_diagonals(reversed_board)
    diagonals.map(&:compact)
  end

  # goes through a padded array and returns diagonal elements (with a lot of extra nil values)
  def padded_diagonals(padded_board)
    diagonals_array = []
    diagonal_limit = ((padded_board[0].length + 2) * 2 / 3) - 1

    diagonal_limit.times do |index|
      one_diagonal = []
      padded_board.length.times { |i| one_diagonal.push(padded_board[i][i + index]) }
      diagonals_array.push(one_diagonal)
    end
    diagonals_array
  end

  # checks all column in @board for 4 consecutive elements, returns element if found else false
  def consecutive_in_columns?
    columns = @board
    check_for_consecutive_in(columns)
  end

  # checks all row in @board for 4 consecutive elements, returns element if found else false
  def consecutive_in_rows?
    rows = grab_rows
    check_for_consecutive_in(rows)
  end

  # checks all diagonals in @board for 4 consecutive elements, returns element if found else false
  def consecutive_in_diagonals?
    diagonals = grab_diagonals
    check_for_consecutive_in(diagonals)
  end

  def tie?
    !@board.flatten.include?('') # there are no spaces on the board
  end

  # uses colorize gem to return a colored coin using color from parameter
  # if parameter given is a blank string returns a black coin with a black background
  def color_coin(color)
    return @coin.colorize(color: :black, background: :black) if color == ''

    @coin.colorize(color: color.to_sym, background: :black)
  end
end
