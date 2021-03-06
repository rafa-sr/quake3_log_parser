# frozen_string_literal: true

describe ClientProcessor do
  include_context 'when log lines'
  let(:id) { 2 }
  let(:name) { 'Zeh' }
  let(:client_processor) { described_class.new }

  describe '#process' do
    context 'when is a client_line' do
      before do
        allow(client_processor).to receive(:connect_client)
        allow(client_processor).to receive(:user_info_change)
        allow(client_processor).to receive(:disconnect_client)
      end

      it 'call connect_client if log_line is client_connect' do
        client_processor.process(LogLine.new(connect_line))

        expect(client_processor).to have_received(:connect_client)
      end

      it 'call user_info_change if log_line is user_info_change' do
        client_processor.process(LogLine.new(user_info_change))

        expect(client_processor).to have_received(:user_info_change)
      end

      it 'call disconnect_client if log_line is disconnect_client' do
        client_processor.process(LogLine.new(disconnect_line))

        expect(client_processor).to have_received(:disconnect_client)
      end
    end

    context 'when is not a client_line' do
      before do
        allow(client_processor).to receive(:connect_client)
        allow(client_processor).to receive(:user_info_change)
        allow(client_processor).to receive(:disconnect_client)
      end

      it 'do not call connect_client when log_line is client_connect' do
        client_processor.process(LogLine.new(kill2_line))

        expect(client_processor).not_to have_received(:connect_client)
      end

      it 'do not call user_info_change when log_line is user_info_change' do
        client_processor.process(LogLine.new(kill2_line))

        expect(client_processor).not_to have_received(:user_info_change)
      end

      it 'do not call disconnect_client when log_line is disconnect_client' do
        client_processor.process(LogLine.new(kill2_line))

        expect(client_processor).not_to have_received(:disconnect_client)
      end
    end

    context 'when process a lots of connections and reconnections' do
      before do
        File.foreach(File.join(ROOT, 'spec/fixture/clients.log')) do |line|
          client_processor.process(LogLine.new(line))
        end
      end

      it 'keep clean the connected clients list (remove old clients)' do
        expect(client_processor.connected_clients.length).to eq 6
      end
    end
  end

  describe '#connect_client' do
    before do
      client_processor.connect_client(id)
    end

    it 'put it on the connected list' do
      client_index = client_processor.find_connected_client(id: id)

      expect(client_index).not_to be nil
    end
  end

  describe '#disconnect_client' do
    before do
      client_processor.connect_client(id)
      client_processor.user_info_change(name, id)
      client_processor.disconnect_client(id)
    end

    it 'put it on the disconnected list' do
      client_index = client_processor.find_disconnected_client(id: id)

      expect(client_index).not_to be nil
    end

    it 'pop it the connected list' do
      client_index = client_processor.find_connected_client(id: id)

      expect(client_index).to be nil
    end
  end

  describe '#user_info_change' do
    before do
      client_processor.connect_client(id)
      client_processor.user_info_change(name, id)
    end

    it 'change tha name of the client' do
      client_index = client_processor.find_connected_client(id: id)

      expect(client_processor.connected_clients[client_index].name).to be name
    end

    context 'when reconnected client' do
      before do
        client_processor.disconnect_client(id)
        client_processor.connect_client(id)
        client_processor.user_info_change(name, id)
      end

      it 'put it back on the connected list' do
        client_index = client_processor.find_connected_client(id: id)

        expect(client_index).not_to be nil
      end

      it 'pop it the connected list' do
        client_index = client_processor.find_disconnected_client(id: id)

        expect(client_index).to be nil
      end
    end

    context 'when reconnected client with different id' do
      let(:changed_id) { 4 }

      before do
        client_processor.disconnect_client(id)
        client_processor.connect_client(changed_id)
        client_processor.user_info_change(name, changed_id)
      end

      it 'remove old client from the connected list' do
        expect(client_processor.connected_clients.length).to eq 1
      end

      it 'put it back on the connected list' do
        client_index = client_processor.find_connected_client(id: changed_id)

        expect(client_index).not_to be nil
      end

      it 'pop it the connected list' do
        client_index = client_processor.find_disconnected_client(id: changed_id)

        expect(client_index).to be nil
      end
    end
  end

  describe '#update_connected_client' do
    before do
      client_processor.connect_client(id)
    end

    it 'update the client name' do
      client_processor.update_connected_client({ name: 'foo' }, id)

      expect(client_processor.find_connected_client(name: 'foo')).not_to be nil
    end

    it 'update the client kills' do
      client_processor.update_connected_client({ kills: 99 }, id)
      client_index = client_processor.find_connected_client(id: id)
      expect(client_processor.connected_clients[client_index].kills).to eq 99
    end
  end
end
