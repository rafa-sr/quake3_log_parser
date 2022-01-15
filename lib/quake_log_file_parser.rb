# frozen_string_literal: true

class QuakeLogFileParser
  attr_reader :matches

  def initialize(file_path)
    @file_path = file_path
    @game_parser = nil
    @matches = []
    @active_match = false
  end

  def parse
    File.foreach(File.join(ROOT, @file_path)) do |line|
      log_line = LogLine.new(line)

      finish_match if @active_match && log_line.init_game?

      finish_match if @active_match && log_line.end_line?

      start_match if log_line.init_game?

      @game_parser.process(log_line) if @active_match
    end
    byebug
  end

  def start_match
    @active_match = true
    @game_parser = GameParser.new
  end

  def finish_match
    @matches << @game_parser.print
    @active_match = false
  end
end
