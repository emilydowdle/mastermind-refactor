def prompt(message)
  puts "=> #{message}"
end

def create_secret_code(code, chars)
  chars.each { |e| code << chars.shuffle.sample }
end

def valid_guess?(input)
  input.length == 4 && input.all? { |e| e == "B" || e == "R" || e == "G" || e == "Y" }
end

def fill_feedback(user_guess, secret_code, feedback)
  user_guess.each_with_index do |e, i|
    if e == secret_code[i]
      feedback[i] = e
    end
  end
end

### game
loop do

  prompt("Welcome to MASTERMIND")
  prompt("Would you like to (p)lay, read the (i)nstructions or (q)uit?")
  initial_user_choice = gets.chomp.upcase

  if initial_user_choice == "I"
    prompt("INSTRUCTIONS: The computer has created a secret code. To win, crack the code by guessing the correct colors and positions. But don't delay! The clock is ticking. Ready?")
  elsif initial_user_choice == "Q"
    prompt("Goodbye!")
    break
  else
  end

  loop do

    prompt("I have generated a beginner sequence with four elements made up of: (r)ed, (g)reen, (b)lue, and (y)ellow. Use (q)uit at any time to end the game.")

    code_possibilities = ["R", "G", "B", "Y"]
    secret_code = []

    create_secret_code(secret_code, code_possibilities)

    prompt("LET'S GET STARTED!")
    puts " ----- ----- ----- ----- "
    puts "|     |     |     |     |"
    puts " ----- ----- ----- ----- "

    start_time = Time.new

    feedback = ["?", "?", "?", "?"]
    correct_colors = 0
    correct_positions = 0
    num_of_guesses = 0

    loop do

      prompt("What's your guess?")
      user_guess = gets.chomp.to_s.upcase.split(//)

      if user_guess == ["Q"]
        break
      elsif user_guess == ["C"]
        prompt("The secret code is: #{secret_code.join("")}")
        break
      else
        loop do
          case
          when valid_guess?(user_guess)
            break
          when user_guess.length < 4
            prompt("That guess is too short.")
            prompt("What's your guess?")
            user_guess = gets.chomp.upcase.split(//)
          when user_guess.length > 4
            prompt("That guess is too long.")
            prompt("What's your guess?")
            user_guess = gets.chomp.upcase.split(//)
          elsif user_guess.to_s != user_guess
            prompt("Those look like numbers. Try B, R, Y or G.")
            prompt("What's your guess?")
            user_guess = gets.chomp.upcase.split(//)
          end
        end
      end

      fill_feedback(user_guess, secret_code, feedback)

      puts feedback.join

      puts " ----- ----- ----- ----- "
      puts "|  #{feedback[0]}  |  #{feedback[1]}  |  #{feedback[2]}  |  #{feedback[3]}  |"
      puts " ----- ----- ----- ----- "

      correct_colors = 0
      secret_code_clone = secret_code.clone

      user_guess.each do |e|
        location = secret_code_clone.index(e)
        if location != nil
          secret_code_clone.delete_at(location)
          correct_colors += 1
        end
      end

      correct_positions = 0
      feedback.each do |e|
        if e != "?"
          correct_positions += 1
        end
      end

      num_of_guesses += 1
      guess_syntax = "guess"
        if num_of_guesses > 1
          guess_syntax = "guesses"
        end

      if feedback.include?("?") == false
        finish_time = Time.new
        time_score = (finish_time - start_time).to_i # duration in seconds
        seconds = (time_score % 60)
        minutes = ((time_score / 60) % 60)

        unless minutes == 1
          minutes_syntax = "minutes"
        else minutes_syntax = "minute"
        end

        unless seconds == 1
          seconds_syntax = "seconds"
        else seconds_syntax = "second"
        end

        prompt("Congratulations! You guessed the sequence #{secret_code.join} in #{num_of_guesses} #{guess_syntax} over #{minutes} #{minutes_syntax}, #{seconds} #{seconds_syntax}.")
        break
      end

      prompt("#{user_guess.join} has #{correct_colors} of the correct elements with #{correct_positions} in the correct positions. You've taken #{num_of_guesses} #{guess_syntax}.")

    end

    prompt("Would you like to (p)lay again? Or (q)uit?")
    play_again = gets.chomp.upcase
    if play_again == "Q"
      break
    end

  end

  prompt("Goodbye!")
  break

end
