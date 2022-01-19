# frozen_string_literal: true

class KillProcessor
  WORLD = 'world'

  attr_reader :total_kills

  def initialize(client_processor)
    @total_kills = 0
    @kills_by_means = {}
    @client_processor = client_processor
  end

  def process(log_line)
    add_kill(KillLogLine.new(log_line.line)) if log_line.kill_line?
  end

  def add_kill(kill_line)
    @total_kills += 1
    if kill_line.killer_id == KillLogLine::WORLD_ID || kill_line.death_id == kill_line.killer_id
      add_score(kill_line.death_id, -1)
      return
    end

    add_score(kill_line.killer_id, 1)
  end

  private

  def add_score(id, amount)
    client_index = @client_processor.find_connected_client(id: id)
    client_score = @client_processor.connected_clients[client_index].kills
    @client_processor.connected_clients[client_index].kills = client_score + amount
  end
end
