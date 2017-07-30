require 'sinatra'
require 'sinatra/reloader' if development?
require './mastermind_reloaded'

configure do
  enable :sessions
  set :session_secret, "secret"
end

set :allowed_colours, ["R","B","Y","G","O","P"]

GAMES = {}

get '/' do
  erb :index, :locals => {}
end

get "/codemaker" do
  session_id = session["session_id"]

  GAMES[session_id] = Mastermind.new
  game = GAMES[session_id]
  game.new_game_maker
  message = "Enter code (RGYBOP) "
  input, win_message, output = nil, nil, nil
  erb :codemaker, :locals => {:message => message, :input => input, :output => output, :win_message => win_message}
end

post "/enterCode" do
  session_id = session["session_id"]
  game = GAMES[session_id]
  input = get_input
  if input.length == 4 
    game.maker.set_code(input)
    until game.breaker.turns >= game.breaker.max_turns
      game.breaker.set_row_ai(game.maker.code)
      output = game.breaker.print_output
      game.breaker.turns += 1
      win_message = game.breaker.check_for_win
    end
  end

  erb :codemaker, :locals => { :output => output, :input => input, :win_message => win_message}
end


get "/codebreaker" do
  session_id = session["session_id"]

  GAMES[session_id] = Mastermind.new
  game = GAMES[session_id]
  game.new_game_breaker
  turns_left = game.breaker.max_turns - game.breaker.turns
  message = "Enter row  (RGYBOP) "
  input, win_message, output = nil, nil, nil
  erb :codebreaker, :locals => {:message => message, :input => input, :output => output,:win_message => win_message, :turns_left => turns_left}
end

post "/enterGuess" do
  session_id = session["session_id"]
  game = GAMES[session_id]
  input = get_input
  if input.length == 4 
    game.breaker.save_rows(input.split(""),game.maker.code)
    output = game.breaker.print_output
    game.breaker.turns += 1
    turns_left = game.breaker.max_turns - game.breaker.turns
    if turns_left > 0
      message = "Enter row  (RGYBOP) "
    else
      message = nil
    end
    win_message = game.breaker.check_for_win
  end

  erb :codebreaker, :locals => {:message => message, :input => input, :output => output,:win_message => win_message, :turns_left => turns_left}
end

post "/newGame" do
  redirect "/"
end

#retrieves input and runs validation
def get_input
  input = params["input"]
  valid_input(input)
end

#validates input by comparing it to allowed colours
def valid_input(input)
  input.upcase!
  n = 0
  if input.length == 4
    while n < 4
      unless settings.allowed_colours.include?(input[n])
        return  message = "Please enter a valid colour (RBYGOP)"
      end
      n+= 1
    end
  else
    return message = "Please enter four colours (RBYGOP)"  
  end
  return input
end

