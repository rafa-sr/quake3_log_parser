# frozen_string_literal: true

class ClientProcessor < Processor
  attr_reader :disconnected_clients, :connected_clients

  def initialize
    @connected_clients = []
    @disconnected_clients = []
  end

  def process(log_line)
    return unless log_line.client_line?

    client_line = ClientLogLine.new(log_line.line)
    connect_client(client_line.id) if client_line.connect?

    user_info_change(client_line.name, client_line.id) if client_line.name_changed?

    disconnect_client(client_line.id) if client_line.disconnect?
  end

  def connect_client(id)
    new_client = Client.new(id: id)
    @connected_clients.append(new_client)
  end

  def user_info_change(name, id)
    client_index = find_disconnected_client(name: name)
    update_connected_client({ name: name }, id) if client_index.nil?
    reconnect_client(client_index, id) unless client_index.nil?
  end

  def disconnect_client(id)
    client_index = find_connected_client(id: id)
    client = @connected_clients.delete_at(client_index)
    @disconnected_clients.append(client)
  end

  def find_connected_client(id: nil, name: nil)
    find_client_by(@connected_clients, id: id, name: name)
  end

  def find_disconnected_client(id: nil, name: nil)
    find_client_by(@disconnected_clients, id: id, name: name)
  end

  def update_connected_client(options, id)
    client_index = find_connected_client(id: id)
    @connected_clients[client_index].name = options[:name] if options[:name]
    @connected_clients[client_index].kills = options[:kills] if options[:kills]
  end

  private

  def reconnect_client(client_index, id)
    client = @disconnected_clients.delete_at(client_index)
    update_connected_client({ name: client.name, kills: client.kills }, id)
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
