# frozen_string_literal: true

class LogLine
  attr_accessor :tokens, :line

  WORDS_REGEX = /\w+/
  BEFORE_KILLER_PLAYER_INDEX = 6
  KILLED = 'killed'
  KILL = 'Kill'
  BY = 'by'
  CLIENT_CONNECT = 'ClientConnect'
  CLIENT_NAME_CHANGED = 'ClientUserinfoChanged'
  CLIENT_BEGIN = 'ClientBegin'
  CLIENT_EVENTS = [CLIENT_CONNECT, CLIENT_NAME_CHANGED, CLIENT_BEGIN].freeze

  def initialize(line)
    @line = line
    @tokens = line.scan(WORDS_REGEX)
  end

  def event
    @event ||= @tokens[2]
  end

  def valid_kill_line?
    event == KILL
  end

  def client_line?
    CLIENT_EVENTS.each { |client_events| return true if event == client_events }
    false
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
