# frozen_string_literal: true

require 'byebug'
class LogLine
  attr_accessor :tokens, :line

  WORDS_WITHOUT_NUMBER_REGEX = /\b[^\d\W]+\b/

  def initialize(line)
    @line = line
    @tokens = line.scan(WORDS_WITHOUT_NUMBER_REGEX)
  end

  def event
    @event ||= @tokens.first
  end

  def death_cause
    @death_cause ||= @tokens.last
  end

  def kill?
    event == 'Kill'
  end
end
