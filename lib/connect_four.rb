require_relative 'board'
require_relative 'display_print'

# class used to interact with Board and handle player inputs
class ConnectFour
  def initialize
    @game_board = Board.new
  end

  def main_menu
    DisplayPrint.menu_screen

    case get_player_input_between(1, 1)
    when 1 then init_rounds
    end
  end

  # starts a game between red and blue, returns winning color
  def init_rounds
    current_player = 'blue'
    until @game_board.win_condition
      one_round_for(current_player)
      current_player = current_player == 'blue' ? 'red' : 'blue' # switch current player
    end
    @game_board.win_condition
  end

  # plays a turn for the specified player color, does not check if game is won
  def one_round_for(player_color)
    system('clear') || system('cls') # clear console

    @game_board.display_board
    DisplayPrint.player_turn(player_color)

    @game_board.drop_coin(player_color, fetch_index_from_player)
  end

  # gets input from terminal and returns input as integer, retries if invalid
  def get_player_input_between(start_num, end_num)
    input = gets.chomp
    raise 'invalid input' unless input =~ /^[#{start_num}-#{end_num}]$/ # input must be between start and end

    input.to_i
  rescue StandardError
    DisplayPrint.input_error_num_between(start_num, end_num)
    retry
  end

  # gets column index (1-7) from player in terminal
  def fetch_index_from_player
    index = get_player_input_between(1, 7) - 1
    raise 'column full' if @game_board.column_full?(index)

    index
  rescue StandardError
    DisplayPrint.column_full_error
    retry
  end

  # allow you to change the symbol used for each coin
  def change_coin(coin_face)
    @game_board.coin = coin_face
  end
end
