class Mastermind
  attr_accessor :breaker, :maker  
#starts a new game, initializes both players and loops the turns.
def new_game_breaker
  @breaker = Codebreaker.new
  @maker = Codemaker.new
  @maker.random_code
end


def new_game_maker
  @breaker = Codebreaker.new
  @maker = Codemaker.new
  @breaker.ai = true
end
end

class Codebreaker 
  attr_accessor :turns, :code_array, :fb_array, :ai
  attr_reader :max_turns, :allowed_colours

#sets turn counter, max turns and sets the allowed colours list
#also sets up the arrays to store the codes and the matches
def initialize
  @max_turns = 12
  @turns = 0
  @allowed_colours = ["R","B","Y","G","O","P"]
  @code_array = []
  @fb_array = []
  @ai = false
end 

# takes the input, saves the row, displays the gameboard and checks for a winning input.
def turn(input,ans)
  if @ai == true
    set_row_ai(ans)
  else
    set_row(input,ans)
  end
  print_output
  @turns += 1
  check_for_win
end
 #ai version of the set row method, randomly generates are code
 def set_row_ai(ans)
  row = []
  n = 0
  while n < 4
    if @turns > 0
      if @fb_array[@turns -1][n] =="BM"
        row.push(@code_array[@turns-1][n])
      else
        row.push(@allowed_colours[rand(5)])
      end
    else
      row.push (@allowed_colours[rand(5)])
    end
    n += 1
  end
  save_rows(row,ans)
end
#human version of the set row method - sets required move by player
def set_row(input,ans)
  message = "Enter row #{@turns +1} (RGYBOP) "
  save_rows(input.split(""),ans)
end

#saves the entered moves to the code array
def save_rows(row,ans)
  @code_array.push(row)
  @fb_array.push(matches(row,ans))
end

def matches(current_row,code_array)
  n = 0
  matches=[]
  while n < 4
    if current_row[n] == code_array[n]
      matches[n] = "BM"
    elsif code_array.include?(current_row[n]) 
      matches[n] = "CM"
    else 
      matches[n] = "  "
    end
    n += 1
  end
  return matches
end

def print_output
  t = 0
  output_arr = []
  while t < @turns + 1
    output_arr << "#{@code_array[t]} #{@fb_array[t]} "
    t += 1
  end
  output_arr
end

#checks after each turn to see if all match, with different outputs depending on the player
def check_for_win
  turns_left = @max_turns - @turns
  if @fb_array[@turns-1].all? {|x| x =="BM"}
    if @ai
      message = "You lose! The computer cracked your code in #{@turns} attempts"
    else
      message =  "You win! You took #{@turns} attempts"
    end
    @turns = @max_turns
  else
    if @turns  >= @max_turns
      if @ai
        message =  "You win! The computer failed to crack your code"
      else
        message =  "Better luck next time!"
      end
    else
      if turns_left > 0
        message =  "#{turns_left} guesses remain"
      else
        message = nil
      end
    end
  end
  message
end

end

#methods for the codemaker
class Codemaker
  attr_reader :code

#sets alllowed colours
def initialize
 @allowed_colours = ["R","B","Y","G","O","P"]
end
  # takes code from human player
  def set_code(input)
    @code = input.split("")
  end
  
#generates a random valid code
def random_code
  n = 0
  @code = ""
  while n < 4
    @code += @allowed_colours[rand(5)]
    n += 1
  end
  return @code
end

end