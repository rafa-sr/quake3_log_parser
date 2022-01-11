# frozen_string_literal: true

class GameProcessor
  attr_reader :disconnected_clients, :connected_clients

  def initialize
    @total_kills = 0
    @kills_scoreboard = {}
    @players = []
    @client_processor = ClientProcessor.new
    @kill_processor = KillProcessor.new(@client_processor)
  end

  def process(log_line)
    # TODO: processors.map(&:process(log_line))
    @client_processor.process(log_line) if log_line.client_line?
    @kill_processor.process(log_line) if log_line.kill_line?
  end

  def players
    @client_processor.connected_clients + @client_processor.disconnected_clients
  end

  def total_kills
    @kill_processor.total_kills
  end
end
