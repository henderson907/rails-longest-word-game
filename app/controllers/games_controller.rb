require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { (65 + rand(26)).chr }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    valid_letters = word_in_grid(@word, @letters)
    valid_word = word_is_valid(@word)

    if valid_letters == false
      @score = "Sorry but #{@word} cannot be built out of #{@letters}"
    elsif valid_letters == true && valid_word == false
      @score = "Sorry but #{@word} does not appear to be a valid english word"
    else
      @score = "Congratulations! #{@word} is a valid English word!"
    end
  end

  private

  def word_in_grid(word, letters)
    word_array = word.upcase.chars
    valid = word_array.all? { |letter| letters.include?(letter) }
    return valid
  end

  def word_is_valid(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialised_dictionary = URI.open(url).read
    dictionary_verification = JSON.parse(serialised_dictionary)
    return dictionary_verification
  end
end
