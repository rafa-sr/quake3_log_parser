# frozen_string_literal: true

class LogLine
  attr_accessor :tokens, :line

  WORDS_REGEX = /\w+/
  KILL = 'Kill'
  CLIENT_CONNECT = 'ClientConnect'
  CLIENT_DISCONNECT = 'ClientDisconnect'
  CLIENT_NAME_CHANGED = 'ClientUserinfoChanged'
  CLIENT_BEGIN = 'ClientBegin'
  CLIENT_EVENTS = [CLIENT_CONNECT, CLIENT_NAME_CHANGED, CLIENT_BEGIN, CLIENT_DISCONNECT].freeze
  SHUT_DOWN = 'ShutdownGame'
  EXIT = 'Exit'
  SPLIT_LINE = '------------------------------------------------------------'
  ENDING_EVENT = [EXIT, SHUT_DOWN].freeze
  INIT_GAME = 'InitGame'

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
    CLIENT_EVENTS.each { |client_event| return true if event == client_event }
    false
  end

  def end_line?
    ENDING_EVENT.each { |ending_event| return true if event == ending_event }
    split_line?
  end

  def init_game?
    event == INIT_GAME
  end

  def split_line?
    @line.split[1] == SPLIT_LINE
  end

  def id
    @id ||= @tokens[3]
  end
end
