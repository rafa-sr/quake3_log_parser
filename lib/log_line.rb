# frozen_string_literal: true

class LogLine
  attr_accessor :line, :event, :killer, :death_cause

  def self.parse(line)
    log_line = new(line)
  end

  def initialize(line)
    @line = line
  end
end
