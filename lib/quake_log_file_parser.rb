# frozen_string_literal: true

class QuakeLogFileParser
  attr_reader :active_match, :game_parser

  def initialize
    @game_parser = nil
    @matches_report = []
    @active_match = false
    @death_causes_report = []
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
    @matches_report << @game_parser.print
    @death_causes_report << @game_parser.print_death_causes
    @active_match = false
  end

  def games_report
    games_reports = []
    @matches_report.each_with_index do |match_report, index|
      games_reports << game_wrapper(match_report, index)
    end
    games_reports
  end

  def deaths_report
    death_reports = []
    @death_causes_report.each_with_index do |death_report, index|
      death_reports << game_wrapper(death_report, index)
    end
    death_reports
  end

  private

  def game_wrapper(report, index)
    wrapper = "game_#{index + 1}" if report[:total_kills]
    wrapper = "game-#{index + 1}" if report[:kills_by_means]
    { wrapper.to_sym => report }
  end
end
