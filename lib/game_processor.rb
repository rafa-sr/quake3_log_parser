# frozen_string_literal: true

class GameProcessor
  attr_accessor :total_kills, :kills_scoreboard, :players
  attr_reader :disconnected_clients, :connected_clients

  WORLD = 'world'

  def initialize
    @total_kills = 0
    @kills_scoreboard = {}
    @players = []
    @connected_clients = []
    @disconnected_clients = []
  end

  def process_client(log_line)
    # return unless log_line.client?
    connect_client(log_line.id) if log_line.connect?

    user_info_change(log_line.name, log_line.id) if log_line.name_changed?

    player_begin(log_line.id) if log_line.begin?

    disconnect_client(log_line.id) if log_line.disconnect?
  end

  def connect_client(id)
    new_client = Client.new(id: id)
    @connected_clients.append(new_client)
  end

  def user_info_change(name, id)
    client_index = find_disconnected_client(name: name)
    change_name(name, id) if client_index.nil?
    reconnect_client(client_index) unless client_index.nil?
  end

  def change_name(name, id)
    client_index = find_connected_client(id: id)
    @connected_clients[client_index].name = name if @connected_clients[client_index].name != name
  end

  def disconnect_client(id)
    client_index = find_connected_client(id: id)
    client = @connected_clients.delete_at(client_index)
    @disconnected_clients.append(client)
  end

  def reconnect_client(client_index)
    client = @disconnected_clients.delete_at(client_index)
    @connected_clients.append(client)
  end

  def find_connected_client(id: nil, name: nil)
    find_client_by(@connected_clients, id: id, name: name)
  end

  def find_disconnected_client(id: nil, name: nil)
    find_client_by(@disconnected_clients, id: id, name: name)
  end

  def add_kill(log_line)
    return unless log_line.kill_line?

    @total_kills += 1
    if log_line.killer_player == WORLD || log_line.death_player == log_line.killer_player
      add_player_score(log_line.death_player, -1)
      return
    end

    add_player_score(log_line.killer_player, 1)
  end

  private

  def player_begin(id)
    @players.each do |clients|
      clients.begin_state = true if clients.id == id
    end
  end

  def find_client_by(client_list, id: nil, name: nil)
    if id.nil? && name.nil?
      raise ArgumentError
        .exception('wrong number of arguments, (please give id or name)')
    end

    return find_by_name(client_list, name) if name

    find_by_id(client_list, id)
  end

  def find_by_id(client_list, id)
    client_list.each_with_index do |client, index|
      return index if client.id == id
    end
    nil
  end

  def find_by_name(client_list, name)
    client_list.each_with_index do |client, index|
      return index if client.name == name
    end
    nil
  end

  def add_player_score(player_name, amount)
    if @kills_scoreboard.include?(player_name)
      player_score = @kills_scoreboard[player_name]
      @kills_scoreboard.store(player_name, player_score + amount)
    else
      @kills_scoreboard.store(player_name, amount)
    end
  end
end
