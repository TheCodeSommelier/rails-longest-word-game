require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    alphabet = ('a'..'z').to_a
    @letters = alphabet.sample(10)
  end

  def score
    @player_word = params[:word]
    @letters = params[:letters].delete(' ')
    @is_an_english_word = english_word?(@player_word)
    @is_a_valid_word = validate_against_grid?(@player_word, @letters)
    @is_a_copy = copy?(@letters, @player_word)
    @score = @player_word.length
  end

  # should validate the string against the grid of the generated letters
  def validate_against_grid?(word, letters)
    word.split.all? { |letter| letters.count(letter) >= word.count(letter) }
  end

  # should check if it is an english word
  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized = URI.open(url).read
    response = JSON.parse(serialized)
    response["found"]
  end

  # should check if the letters are just letters from the grid. It cannot be a copy
  def copy?(letters, word)
    letters == word
  end
end
