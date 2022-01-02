# frozen_string_literal: true

class KillDataCollector
  attr_accessor :total_kills, :kills_scoreboard, :players

  WORLD = 'world'

  def initialize
    @total_kills = 0
    @kills_scoreboard = {}
    @players = []
  end

  def add(log_line)
    return unless log_line.kill_line?

    @total_kills += 1
    if log_line.killer_player == WORLD || log_line.death_player == log_line.killer_player
      add_player_score(log_line.death_player, -1)
      return
    end

    add_player_score(log_line.killer_player, 1)
  end

  private

  def add_player_score(player_name, amount)
    if @kills_scoreboard.include?(player_name)
      player_score = @kills_scoreboard[player_name]
      @kills_scoreboard.store(player_name, player_score + amount)
    else
      @kills_scoreboard.store(player_name, amount)
    end
  end
end
