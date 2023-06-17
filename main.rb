# frozen_string_literal: true

# Mastermind
class Mastermind
  def initialize
    @comp = Computer.new
    @human = Human.new
  end
  
  def play
    12.times {
      human.guess_color
      return puts 'HUMAN WON' if human.guesses == computer.code
    }
  end
end

# Player
class Player
  def initialize
    @lives = 12
  end

  private

  def input_troubles
    begin
      input = gets.chomp
      input = Integer(input)
    rescue ArgumentError
      puts 'Not a number, please input a number from (1-6): '
      retry
    end
    input
  end
end

# Human
class Human < Player
  attr_accessor :guesses

  def guess_color
    loop do
      puts 'Input a 4 digit number from with each digit in between 1 to 6: '
      self.guesses = input_troubles.to_s.split('').map do |digit|
        digit = Integer(digit)
        digit if digit.between?(1, 6)
      end
      break if guesses.length == 4 && !guesses.include?(nil)

      puts "Remember every digit has to be between 1 to 6 and 4 digits long. Try again.\n"
    end
  end
end

# Computer
class Computer < Player
  def initialize
    super
    @code = Array.new(4).map { rand(1..6) }
  end

  def location_hint(guess)
    index = 0
    @correct_location = @code.filter do |digit|
      state = (digit == guess[index])
      index += 1
      state
    end
  end

  def number_hint(guess)
    @correct_number = @code.filter { |digit| guess.include?(digit) } - @correct_location
  end
end
