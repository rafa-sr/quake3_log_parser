# frozen_string_literal: true

class KillProcessor
  attr_reader :total_kills

  def initialize(client_processor)
    @total_kills = 0
    @client_processor = client_processor
  end

  def process(log_line)
    add_kill(KillLogLine.new(log_line.line)) if log_line.kill_line?
  end

  def add_kill(log_line)
    return unless log_line.kill_line?

    @total_kills += 1
    if log_line.killer_id == KillLogLine::WORLD_ID || log_line.death_id == log_line.killer_id
      add_score(log_line.death_id, -1)
      return
    end

    add_score(log_line.killer_id, 1)
  end

  private

  def add_score(id, amount)
    client_index = @client_processor.find_connected_client(id: id)
    client_score = @client_processor.connected_clients[client_index].kills
    @client_processor.connected_clients[client_index].kills = client_score + amount
  end
end
