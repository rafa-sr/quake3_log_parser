# frozen_string_literal: true

class QuakeLogFileParser
  attr_reader :matches_report, :active_match, :game_parser

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

  def matches_report
    reports = []
    @matches_report.each_with_index do |match, index|
      reports << print_match(match, index)
    end
    reports
  end

  def death_causes_report
    death_reports = []
    @death_causes_report.each_with_index do |death_report, index|
      death_reports << print_death_causes(death_report, index)
    end
    death_reports
  end

  private

  def print_death_causes(death_report, index)
    means_of_death_n = "game-#{index + 1}"
    { means_of_death_n.to_sym => death_report }
  end

  def print_match(match, index)
    game_n = "game_#{index + 1}"
    { game_n.to_sym => match }
  end
end
