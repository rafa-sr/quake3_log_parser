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
      game_n = "game_#{index + 1}"
      game_to_print = { game_n => match }
      json = JSON.pretty_generate(game_to_print)
      puts json
    end
  end
end
