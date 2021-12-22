# frozen_string_literal: true

require 'byebug'
class LogLine
  attr_accessor :tokens, :line

  WORDS_REGEX = /\w+/

  def initialize(line)
    @line = line
    @tokens = line.scan(WORDS_REGEX)
  end

  def event
    @event ||= @tokens[2]
  end

  def death_cause
    @death_cause ||= @tokens.last
  end

  def killer_player
    before_players_info = 6
    players_info = @tokens.drop(before_players_info)
    killer_name = ''
    players_info.each_with_index do |token, index|
      return killer_name if token == 'killed'

      killer_name += token if index.zero?
      killer_name = "#{killer_name} #{token}" if index.positive?
    end
    nil
  end

  def kill?
    event == 'Kill'
  end
end
