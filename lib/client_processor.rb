# frozen_string_literal: true

class ClientProcessor
  attr_reader :disconnected_clients, :connected_clients

  def initialize
    @connected_clients = []
    @disconnected_clients = []
  end

  def process(log_line)
    # return unless log_line.client?
    connect_client(log_line.id) if log_line.connect?

    user_info_change(log_line.name, log_line.id) if log_line.name_changed?

    # player_begin(log_line.id) if log_line.begin?

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
end
