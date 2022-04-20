require 'colorize'

# contains various console puts for ConnectFour
module DisplayPrint
  def self.input_index_error
    puts "\n\nInvalid Input, input must be a number from 1 to 7\nTry Again"
  end

  def self.player_turn(player_color)
    player_name = player_color.colorize(color: :black, background: player_color.to_sym)
    puts "\n#{player_name} Turn:"
    puts 'Enter the column number u want to drop your coin in. (1 - 7s)'
  end
end
