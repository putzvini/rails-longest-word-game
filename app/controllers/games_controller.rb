require "open-uri"

class GamesController < ApplicationController
  def new
    @@grid = 10.times.map { ("A".."Z").to_a.sample }
    @grid = @@grid
  end

  def score
    @word_input = params[:word_input]
    @score = run_game(@word_input)
    if @score[0] == false
      @result = "#{@word_input} is not an english word"
    elsif @score[1] == false
      @result = "#{@word_input} is not in the grid"
    elsif @score[2] == 0
      @result = "0 points"
    else
      @result = "#{@word_input} has a score of #{@score[2]}"
    end
  end
  
  def run_game(attempt)
    # TODO: runs the game and return detailed hash of result
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    hash = JSON.parse(open(url).read)
    par1 = hash['found']
    word = attempt.split("")
    gr = @@grid.map { |i| i.downcase }
    par2 = word.all? { |i| gr.delete_at(gr.index(i)) if gr.include?(i) }
    points = par1 && par2 ? word.length : 0
    return [par1, par2, points]
  end
  
#   def message(par1, par2)
#     return "Well done!!!" if par1 && par2
#     return "Not an english word" unless par1
#     return "Not in the grid" unless par2
#   end
end
