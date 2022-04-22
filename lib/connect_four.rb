require_relative 'board'
require_relative 'display_print'

# class used to interact with Board and handle player inputs
class ConnectFour
  def initialize
    @game_board = Board.new
  end

  # gets input from terminal and returns input as integer, retries if invalid
  def input_index
    input = gets.chomp
    raise 'invalid input' unless input =~ /^[1-7]$/ # input must be between 1 to 7

    index = input.to_i - 1
    raise 'column full' if @game_board.column_full?(index)

    index
  rescue StandardError => e
    DisplayPrint.input_index_error if e.message == 'invalid input'
    DisplayPrint.column_full_error if e.message == 'column full'
    retry
  end

  # acts as an visual interface to #drop_coin, does not check if game is won
  def one_round(player_color)
    system('clear') || system('cls') # clear console

    @game_board.display_board
    DisplayPrint.player_turn(player_color)

    index = input_index
    @game_board.drop_coin(player_color, index)
  end

  # starts a game between red and blue, returns winning color
  def init_rounds
    current_player = 'blue'
    condition = @game_board.win_condition
    until condition
      one_round(current_player)
      current_player = current_player == 'blue' ? 'red' : 'blue'
      condition = @game_board.win_condition
    end
    condition
  end

  # allow you to change the symbol used for each coin
  def change_coin(coin_face)
    @game_board.coin = coin_face
  end
end
