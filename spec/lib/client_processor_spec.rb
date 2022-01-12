# frozen_string_literal: true

describe ClientProcessor do
  include_context 'when log lines'
  include_context 'when game processor'
  describe '#process' do
    let(:game_parser) do
      game_parser = described_class.new
      line = ClientLogLine.new(connect_line)
      game_parser.process(line)
      game_parser
    end

    context 'when client Connect' do
      it 'create a client and add it to the connectes list' do
        expect(game_parser.connected_clients.first.id).to eq '2'
      end

      it 'only create clients with different id' do
        player1 = game_parser.connected_clients.first
        line = ClientLogLine.new(connect_line)

        game_parser.process(line)

        expect(game_parser.connected_clients.first).to be player1
      end

      it 'begin on false for a fresh connected client' do
        # TODO: delete looks likes is not needed
        # line = ClientLogLine.new(begin_line)

        # game_parser.process_client(line)

        # expect(game_parser.players.first.begin?).to eq false
      end
    end

    context 'when client Disconnect' do
      it 'add it to the disconnected client list' do
        line = ClientLogLine.new(disconnect_line)
        game_parser.process(line)

        expect(game_parser.disconnected_clients.length).to eq 1
      end

      it 'remove the client 2 from the connected client list' do
        line = ClientLogLine.new(disconnect_line)
        game_parser.process(line)

        expect(game_parser.connected_clients.length).to eq 0
      end
    end

    context 'when client connect, disconnect and connect' do
      before do
        line_disco = ClientLogLine.new(disconnect_line)
        line_connect = ClientLogLine.new(connect_line)
        game_parser.process(line_disco)
        game_parser.process(line_connect)
      end

      it 'add it again to the connected client list' do
        expect(game_parser.connected_clients.length).to eq 1
      end
    end

    context 'when ClientUserinfoChanged' do
      it 'initialize the name if there is no name' do
        line = ClientLogLine.new(user_info_change)

        game_parser.process(line)

        expect(game_parser.connected_clients.first.name).to eq 'Oootsimo'
      end

      it 'and process the same name twice, leave the same name' do
        line = ClientLogLine.new(user_info_change)

        game_parser.process(line)
        game_parser.process(line)

        expect(game_parser.connected_clients.first.name).to eq 'Oootsimo'
      end

      it 'from a disconnected client, pop it from the disconnected list' do
        game_parser = reconnect_name_change

        expect(game_parser.find_disconnected_client(name: 'Dono da Bola')).to be nil
      end

      it 'from a disconnected client, put it back on the connected list' do
        game_parser = reconnect_name_change

        expect(game_parser.find_connected_client(name: 'Dono da Bola')).not_to be nil
      end
    end

    it 'begin on true when ClientBegin' do
      # TODO: delete looks like is not needed
      # line = ClientLogLine.new(begin_line)

      # game_parser.process_client(line)

      # expect(game_parser.players.first.begin?).to eq true
    end
  end
end
