# frozen_string_literal: true

require 'byebug'
class LogLine
  attr_accessor :tokens, :line

  WORDS_REGEX = /\w+/
  BEFORE_KILLER_PLAYER_INDEX = 6
  KILLED = 'killed'
  KILL = 'Kill'
  BY = 'by'

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
    before_killed_tokens = @tokens.drop(BEFORE_KILLER_PLAYER_INDEX)
    parse_player_name(before_killed_tokens, KILLED)
  end

  def death_player
    after_killed_index = find_killed_word_index + 1
    after_killed_tokens = @tokens.drop(after_killed_index)
    parse_player_name(after_killed_tokens, BY)
  end

  def find_killed_word_index
    @tokens.each_with_index { |token, index| return index if token == KILLED }
  end

  def valid_kill_line?
    event == KILL
  end

  private

  def parse_player_name(player_tokens, split_by)
    player_name = ''
    player_tokens.each_with_index do |token, index|
      return player_name if token == split_by

      player_name += token if index.zero?
      player_name = "#{player_name} #{token}" if index.positive?
    end
  end
end
