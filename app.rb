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
  create_game

  set_variables_maker

  erb :codemaker, :locals => {:message => @message, :input => @input, :output => @output, :win_message => @win_message}
end

post "/codemaker" do
  get_game

  take_turn_maker

  erb :codemaker, :locals => { :output => @output, :input => @input, :win_message => @win_message}
end


get "/codebreaker" do
  create_game

  set_variables_breaker

  erb :codebreaker, :locals => {:message => @message, :input => @input, :output => @output,:win_message => @win_message, :turns_left => @turns_left}
end

post "/codebreaker" do

  get_game

  take_turn_breaker

  erb :codebreaker, :locals => {:message => @message, :input => @input, :output => @output,:win_message => @win_message, :turns_left => @turns_left}
end

post "/newGame" do
  redirect "/"
end



def button_input
  input = ["test"]
  if !params["r"].nil?
    input << "r"
    params["r"] = nil
  elsif !params["g"].nil?
    input << "g"
    params["g"] = nil
  elsif !params["y"].nil?
    input << "y"
    params["y"] = nil
  elsif !params["b"].nil?
    input << "b"
    params["b"] = nil
  elsif !params["o"].nil?
    input << "o"
    params["o"] = nil
  elsif !params["p"].nil?
    input << "p"
    params["p"] = nil
  end
  valid_input(input.join(""))
end