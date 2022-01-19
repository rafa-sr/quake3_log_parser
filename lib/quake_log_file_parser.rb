# frozen_string_literal: true

class QuakeLogFileParser
  attr_reader :matches, :active_match, :game_parser

  def initialize
    @game_parser = nil
    @matches = []
    @active_match = false
    @ranking_score = []
  end

  def parse(line)
    log_line = LogLine.new(line)

    finish_match if @active_match && log_line.init_game?

    finish_match if @active_match && log_line.end_line?

    start_match if log_line.init_game?

    @game_parser.process(log_line) if @active_match
  end

  def start_match
    @active_match = true
    @game_parser = GameParser.new
  end

  def finish_match
    @matches << @game_parser.print
    @active_match = false
  end

  def print
    @matches.each_with_index do |match, index|
      ranking = match[:ranking]
      match.delete(:ranking)
      print_match(match,index)
      print_match_ranking(ranking, index)
    end
  end

  private

  def print_match(match, index)
    game_n = "game_#{index + 1}"
    game_to_print = { game_n => match }
    json_match = JSON.pretty_generate(game_to_print)
    puts json_match unless ENV['ENV'] == 'test'
  end

  def print_match_ranking(ranking, index)
    ranking_n = "game_#{index + 1}_ranking"
    ranking_to_print = { ranking_n => ranking }
    json_ranking = JSON.generate(ranking_to_print, array_nl: "\n", space: ' ', indent: ' ')
    puts json_ranking unless ENV['ENV'] == 'test'
  end
end
