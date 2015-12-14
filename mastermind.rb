require_relative 'code'

class Game
  attr_accessor :guess_count, :start_time

  def initialize
    @guess_count = 0
    @start_time = Time.now
  end

  def start
    @code = fetch_code
    start_game
  end

  def fetch_code
    c = Code.new
    c.generate
  end

  def prompt(message)
    puts "=> #{message}"
  end

  def start_game
    prompt("Welcome to MASTERMIND")
    prompt("Would you like to (p)lay, read the (i)nstructions or (q)uit?")
    input
  end

  def input
    input = gets.chomp.upcase
    case
    when input == "Q"
      quit
    when input == "I"
      instructions
    when input == "P"
      begin_play
    when input == "C"
      cheater
    else
      user_guess(input)
    end
  end

  def quit
    prompt("Goodbye!")
  end

  def instructions
    prompt("The computer has created a secret code. To win, crack the code by guessing the correct colors and positions. But don't delay! The clock is ticking.")
    prompt("Would you like to (p)lay, read the (i)nstructions or (q)uit?")
    input
  end

  def begin_play
    prompt("I have generated a beginner sequence with four elements made up of: (r)ed, (g)reen, (b)lue, and (y)ellow. Use (q)uit at any time to end the game.")
    start_time
    prompt("What's your first guess?")
    input
  end

  def next_turn
    prompt("What's your next guess?")
    input
  end

  def cheater
    prompt("The secret code is: #{@code.join}")
    next_turn
  end

  def user_guess(guess)
    guess_arr = guess.chars
    if !valid_guess?(guess_arr)
      prompt("That's not a valid guess.")
      next_turn
    else
      feedback(guess_arr)
    end
  end

  def valid_guess?(guess)
    valid_inputs = %w( B R G Y )
    guess.length == 4 && guess.all? { |letter| valid_inputs.include? letter }
  end

  def correct_colors(guess)
    guess.uniq.find_all { |e| @code.uniq.include? e }.count
  end

  def correct_positions(guess)
    combo = @code.zip(guess)
    combo.find_all { |e| e[0] == e[1] }.count
  end

  def guess_syntax
    guess_count == 1 ? "guess" : "guesses"
  end

  def minutes_syntax(minutes)
    minutes == 1 ? "minute" : "minutes"
  end

  def seconds_syntax(seconds)
    seconds == 1 ? "second" : "seconds"
  end

  def game_time
    time_score = ((Time.now - @start_time).to_i)
    minutes = time_score / 60
    seconds = time_score % 60
    "#{minutes} #{minutes_syntax(minutes)} and #{seconds} #{seconds_syntax(seconds)}"
  end

  def feedback(guess)
    if @code == guess
      prompt("Congratulations! You guessed the sequence #{@code.join} in #{guess_count} #{guess_syntax} with a time score of #{game_time}.")
    else
      @guess_count += 1
      prompt("#{guess.join} has #{correct_colors(guess)} of the correct elements with #{correct_positions(guess)} in the correct positions. You've taken #{guess_count} #{guess_syntax}.")
      next_turn
    end
  end
end

mastermind = Game.new
mastermind.start
