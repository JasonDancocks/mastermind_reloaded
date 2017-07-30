#Methods to get and valididate input to match allowed colours
class Player
   
   # retrieves input and runs validation
   def get_input
    input= gets.chomp.upcase
    until valid_input(input)
      input = gets.chomp.upcase
    end
    return input
  end
  
  #validates input by comparing it to allowed colours
   def valid_input(input)
    n = 0
    if input.length == 4
      while n < 4
        unless @allowed_colours.include?(input[n])
          puts "Please enter a valid colour (RBYGOP)"
          return false
        end
        n+= 1
      end
    else
      puts "Please enter four colours (RBYGOP)"
      return false
    end
    return true
  end
end

#contains methods for the codebreaker player
class Codebreaker < Player
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
  
  #human version of the set row method - sets reuqired move by player
  def set_row(ans)
    puts "Enter row #{@turns +1} (RGYBOP) "
    save_rows(get_input.split(""),ans)
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

  #saves the entered moves to the code array
  def save_rows(row,ans)
    @code_array.push(row)
    @fb_array.push(matches(row,ans))
  end
  
  #checks for matches, allocates "BM" for both matching and "CM" for colour matches

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
  
  # prints entire gameboard and corresponding matches each turn  
  def print_output
    t = 0
    while t < @turns + 1
      puts "#{@code_array[t]} #{@fb_array[t]}"
      t += 1
    end
  end
  
  #checks after each turn to see if all match, with different outputs depending on the player
  def check_for_win
    if @fb_array[@turns-1].all? {|x| x =="BM"}
      if @ai
        puts "You lose! The computer cracked your code in #{@turns} attempts"
      else
        puts "You win! You took #{@turns} attempts"
      end
        @turns = @max_turns
    else
      if @turns  == @max_turns
        puts "#{@max_turns - @turns } guesses remain"
        if @ai
          puts "You win! The computer failed to crack your code"
        else
          puts "Better luck next time!"
        end
      else
        puts "#{@max_turns - @turns  } guesses remain"
      end
    end
  end

  # takes the input, saves the row, displays the gameboard and checks for a winning input.
  def turn(ans)
    if @ai == true
      set_row_ai(ans)
    else
      set_row(ans)
    end
    print_output
    @turns += 1
    check_for_win
  end
end

#methods for the codemaker
class Codemaker < Player
  attr_reader:code, :allowed_colours
  
  #sets alllowed colours
  def initialize
   @allowed_colours = ["R","B","Y","G","O","P"]
  end
  # takes code from human player
  def set_code
    puts "Please enter code"
    @code = get_input.split("")
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