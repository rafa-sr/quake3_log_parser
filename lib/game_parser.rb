# frozen_string_literal: true

class GameParser
  attr_reader :disconnected_clients, :connected_clients

  def initialize
    @total_kills = 0
    @players = []
    init_processors
  end

  def process(log_line)
    @processors.each { |processor| processor.process(log_line) }
  end

  def init_processors
    @client_processor = ClientProcessor.new
    @kill_processor = KillProcessor.new(@client_processor)
    @processors = []
    @processors << @client_processor << @kill_processor
  end

  def players
    @client_processor.connected_clients + @client_processor.disconnected_clients
  end

  def total_kills
    @kill_processor.total_kills
  end

  def kills
    players_kills = {}
    ranking.each do |player|
      players_kills.merge!({ player[:name] => player[:score] })
    end
    players_kills
  end

  def players_name
    players.map(&:name)
  end

  def print
    { total_kills: total_kills,
      players:     players_name,
      kills:       kills }
  end

  private

  def ranking
    players_hash.sort_by { |player| player[:score] }.reverse!
  end

  def players_hash
    players_table = []
    players.each do |player|
      players_table.append({ score: player.kills, name: player.name, client: player.id.to_i })
    end
    players_table
  end
end
