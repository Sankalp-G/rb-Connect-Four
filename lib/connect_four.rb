require_relative 'display_print'

# class used to interact with Board and handle player inputs
class ConnectFour
  # gets input from terminal and returns input as integer, retries if invalid
  def input_index
    input = gets.chomp
    raise unless input =~ /^[1-7]$/ # input must be between 1 to 7

    input.to_i
  rescue StandardError
    DisplayPrint.input_index_error
    retry
  end
end
