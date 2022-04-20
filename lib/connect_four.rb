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
    raise unless input =~ /^[1-7]$/ # input must be between 1 to 7

    input.to_i
  rescue StandardError
    DisplayPrint.input_index_error
    retry
  end

  # acts as an visual interface to #drop_coin, does not check if game is won
  def one_round(player_color)
    system('clear') || system('cls') # clear console

    @game_board.display_board
    DisplayPrint.player_turn(player_color)

    index = input_index - 1
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
end
