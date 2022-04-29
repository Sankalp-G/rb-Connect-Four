require_relative 'connect_four'

# This file contains the basic code required to run the game
# just run this file with ruby and the game should start in your terminal

c4 = ConnectFour.new

# you can use the change coin method to change the default coin face
# c4.change_coin_to('0')

c4.start_game
