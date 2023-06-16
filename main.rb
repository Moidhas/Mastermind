# frozen_string_literal: true

# Mastermind
class Mastermind

  def initialize
    comp = Computer.new
    player = Human.new
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
  def initialize
    super
    @guesses = Array.new(6)
  end

  def guess_color
    loop do
      puts 'Input a number from (1-6): '
      guess = input_troubles
      break guess if guess.between?(1, 6)

      puts "This guess is not between 1 and 6, Try again.\n"
    end
  end
end

# Computer
class Computer < Player
  def initialize
    super
    @code = Array.new(6).map { rand(1..6) }
  end
end
