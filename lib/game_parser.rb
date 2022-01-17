# frozen_string_literal: true

class GameParser
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

  def kills
    players_kills = {}
    players.each do |player|
      players_kills.merge!({ player.name => player.kills })
    end
    players_kills
  end

  def players_name
    players.map(&:name)
  end

  def print
    { total_kills: total_kills,
      players:     players_name,
      kills:       kills,
      ranking:     ranking }
  end

  def ranking
    players_hash.sort_by { |player| player[:score] }.reverse!
  end

  private

  def players_hash
    players_table = []
    players.each do |player|
      players_table.append({ score: player.kills, client: player.id.to_i, name: player.name })
    end
    players_table
  end
end
