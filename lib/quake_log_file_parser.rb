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

  def report
    report = []
    @matches.each_with_index do |match, index|
      report << print_match(match, index)
    end
    report
  end

  private

  def print_match(match, index)
    game_n = "game_#{index + 1}"
    { game_n.to_sym => match }
  end
end
