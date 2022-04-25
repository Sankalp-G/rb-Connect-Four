require 'colorize'

# contains various console puts for ConnectFour
module DisplayPrint
  def self.logo_splash_screen
    puts <<~'HEREDOC'
      ┏━━━┓              ┏┓ ┏━━━┓
      ┃┏━┓┃             ┏┛┗┓┃┏━━┛
      ┃┃ ┗┏━━┳━┓┏━┓┏━━┳━┻┓┏┛┃┗━━┳━━┳┓┏┳━┓
      ┃┃ ┏┫┏┓┃┏┓┫┏┓┫┃━┫┏━┫┃ ┃┏━━┫┏┓┃┃┃┃┏┛
      ┃┗━┛┃┗┛┃┃┃┃┃┃┃┃━┫┗━┫┗┓┃┃  ┃┗┛┃┗┛┃┃
      ┗━━━┻━━┻┛┗┻┛┗┻━━┻━━┻━┛┗┛  ┗━━┻━━┻┛
    HEREDOC
  end

  def self.menu_screen
    system('clear') || system('cls') # clear console

    logo_splash_screen
    puts "\n\nEnter the number for the option you want to choose"
    puts '[1] - Start Game'
  end

  def self.player_turn(player_color)
    player_name = player_color.colorize(color: :black, background: player_color.to_sym)
    puts "\n#{player_name} Turn:"
    puts 'Enter the column number u want to drop your coin in. (1 - 7)'
  end

  def self.game_over_text_for(winner)
    if winner == 'tie'
      puts "\n\nTHE GAME ENDS IN A TIE!\n\n"
    else
      winner_with_color = winner.colorize(color: :black, background: winner.to_sym)
      puts "\n\n#{winner_with_color} HAS WON THE GAME! WELL DONE!\n\n"
    end

    puts '[1] - Play Again'
    puts '[2] - Main Menu'
    puts '[3] - Exit'
  end

  def self.input_error_num_between(start_num, end_num)
    puts "\n\nInvalid Input, input must be a number from #{start_num} to #{end_num}\nTry Again"
  end

  def self.column_full_error
    puts "\n\nThat column is full, Choose a different column\n"
  end
end
