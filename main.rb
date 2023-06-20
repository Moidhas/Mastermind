# frozen_string_literal: true

# Mastermind class
class Mastermind
  def initialize
    restart
  end

  def play
    loop do
      play_human if @human.player_mode == '2'
      play_computer if @human.player_mode == '1'
      print 'To play again press Y or any other key to exit: '
      play_again = gets.chomp.upcase
      break unless play_again == 'Y'

      restart
    end
  end

  private

  def play_human
    12.times do
      @human.guess_color
      return puts "HUMAN WON, the code was #{@comp.code}" if @human.guess == @comp.code

      @comp.print_hint(@human.guess, @comp.code)
    end
    puts 'COMPUTER WON'
    puts "The correct code was #{@comp.code}"
  end

  def play_computer
    12.times do
      @comp.print_guess
      @comp.print_hint(@comp.guess, @human.code)
      return puts 'COMPUTER WON' if @human.code == @comp.guess

      @comp.new_guess(@human.code)
    end
  end

  def restart
    @comp = Computer.new
    @human = Human.new
  end
end

# Player
class Player
  LOCATION = 0
  COLOR = 1

  attr_reader :guess, :code

  def initialize
    @code = Array.new(4).map { rand(1..6) }
    @guess = [1, 1, 2, 2]
  end

  def print_hint(guessed, coded)
    print 'Clues: '
    loc_peg = location_n_color(guessed, coded)
    loc_peg.each do |hint|
      print "\e[91m\u25CF\e[0m " if hint == LOCATION
      print "\e[37m\u25CB\e[0m " if hint == COLOR
    end
    puts
  end

  private

  def input_troubles
    begin
      input = gets.chomp
      input = Integer(input)
    rescue ArgumentError
      print "\n Not a number, please input a number: "
      retry
    end
    input
  end

  def location_n_color(guessed, coded)
    loc_peg = location_hint(guessed, coded)
    col_peg = color_hint(guessed, coded)
    loc_col = Array.new()
    loc_peg.each_with_index do |hint, index|
      if hint
        loc_col.push(LOCATION)
      elsif col_peg[index]
        loc_col.push(COLOR) 
      end
    end
    loc_col
  end

  def location_hint(guessed, coded)
    index = -1
    coded.map do |digit|
      index += 1
      digit if digit == guessed[index]
    end
  end

  def color_hint(guessed, coded)
    coded.map { |digit| digit if guessed.include?(digit) }
  end
end

# Human < Player
class Human < Player
  attr_reader :player_mode

  def initialize
    super
    @player_mode = player_select
    code_select if @player_mode == '1'
  end

  def guess_color
    @guess = number_inputs
  end

  private

  def code_select
    puts 'Select a Master Code: '
    @code = number_inputs
  end

  def player_select
    puts 'Press 1 to be the Code Maker'
    puts 'Press 2 to be the Code Breaker'
    loop do
      player_mode = gets.chomp
      break player_mode if %w[1 2].include?(player_mode)

      puts 'Remember pick between the numbers 1 and 2'
    end
  end

  def number_inputs
    loop do
      print "\nInput a 4 digit number from with each digit in between 1 to 6: "
      retval = input_troubles.to_s.split('').map do |digit|
        digit = Integer(digit)
        digit if digit.between?(1, 6)
      end
      break retval if retval.length == 4 && !retval.include?(nil)

      puts "Remember every digit has to be between 1 to 6 and 4 digits long. Try again.\n"
    end
  end
end

# Computer
class Computer < Player
  def initialize
    super
    @soln_set = [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
    @soln_set.delete([1, 1, 2, 2])
  end

  def print_guess
    puts "Computer guessed #{guess}"
  end

  def new_guess(hum_code)
    remove_solns(hum_code)
    @guess = @soln_set.shift
  end

  private

  def remove_solns(hum_code)
    loc = location_hint(guess, hum_code).compact.length
    col = color_hint(guess, hum_code).compact.length
    @soln_set.each do |soln|
      lch = location_hint(guess, soln).compact.length
      clh = color_hint(guess, soln).compact.length
      @soln_set.delete(soln) unless lch == loc && clh == col
    end
  end
end

game = Mastermind.new
game.play
