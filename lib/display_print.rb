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

  def self.input_error_num_between(start_num, end_num)
    puts "\n\nInvalid Input, input must be a number from #{start_num} to #{end_num}\nTry Again"
  end

  def self.column_full_error
    puts "\n\nThat column is full, Choose a different column\n"
  end
end
