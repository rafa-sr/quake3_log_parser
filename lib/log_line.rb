# frozen_string_literal: true

class LogLine
  attr_accessor :tokens, :line

  WORDS_REGEX = /\w+/
  KILL = 'Kill'
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

  def kill_line?
    event == KILL
  end

  def client_line?
    CLIENT_EVENTS.each { |client_events| return true if event == client_events }
    false
  end

  def id
    @id ||= @tokens[3]
  end
end
