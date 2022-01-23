# frozen_string_literal: true

class ClientHelper
  def self.client_kills(id: nil, client_processor: nil)
    client_index = client_processor.find_connected_client(id: id)
    client_index = client_processor.find_disconnected_client(id: id) if client_index.nil?
    client_processor.connected_clients[client_index].kills
  end
end
