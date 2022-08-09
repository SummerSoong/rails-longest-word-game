require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    i = 0
    @letters = []
    while i < 10
      @letters << ('a'..'z').to_a.sample
      i += 1
    end
  end

  def score
    # The word can’t be built out of the original grid
    @end_time = Time.now
    @check_grid = check_grid?(params[:letters], params[:guess])
    @check_english_word = check_english_word?(params[:guess])
    @start_time = params[:start_time]
    @score = (params[:guess].length / ((@end_time - Time.parse(@start_time)) / 60_000)).round
  end

  # def create
  #   session[:current_user_id] = @user.id
  # end

  def check_grid?(letters, word)
    word.chars.each do |letter|
      if letters.chars.include?(letter)
        word.delete(letter)
      else
        return false
      end
    end
  end

  def check_english_word?(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    user["found"]
  end

end
