# frozen_string_literal: true

class KillProcessor < Processor
  attr_reader :total_kills, :death_causes

  def initialize(client_processor)
    @total_kills = 0
    @client_processor = client_processor
    @death_causes = {}
    MeansOfDeath::DEATH_CAUSES.each { |death_cause| @death_causes.merge!({ death_cause.to_sym => 0 }) }
  end

  def process(log_line)
    add_kill(KillLogLine.new(log_line.line)) if log_line.kill_line?
  end

  def add_kill(kill_log_line)
    @total_kills += 1
    @death_causes[kill_log_line.death_cause.to_sym] += 1

    if kill_log_line.killer_id == KillLogLine::WORLD_ID || kill_log_line.death_id == kill_log_line.killer_id
      add_score(kill_log_line.death_id, -1)
      return
    end

    add_score(kill_log_line.killer_id, 1)
  end

  private

  def add_score(id, amount)
    client_index = @client_processor.find_connected_client(id: id)
    client_score = @client_processor.connected_clients[client_index].kills
    @client_processor.connected_clients[client_index].kills = client_score + amount
  end
end
