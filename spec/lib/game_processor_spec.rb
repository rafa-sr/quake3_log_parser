# frozen_string_literal: true

describe GameProcessor do
  include_context 'when log lines'
  include_context 'when game processor'
  describe '#process_client' do
    let(:game_processor) do
      game_processor = described_class.new
      line = ClientLogLine.new(connect_line)
      game_processor.process_client(line)
      game_processor
    end

    context 'when client Connect' do
      it 'create a client and add it to the connectes list' do
        expect(game_processor.connected_clients.first.id).to eq '2'
      end

      it 'only create clients with different id' do
        player1 = game_processor.connected_clients.first
        line = ClientLogLine.new(connect_line)

        game_processor.process_client(line)

        expect(game_processor.connected_clients.first).to be player1
      end

      it 'begin on false for a fresh connected client' do
        # TODO: delete looks likes is not needed
        # line = ClientLogLine.new(begin_line)

        # game_processor.process_client(line)

        # expect(game_processor.players.first.begin?).to eq false
      end
    end

    context 'when client Disconnect' do
      it 'add it to the disconnected client list' do
        line = ClientLogLine.new(disconnect_line)
        game_processor.process_client(line)

        expect(game_processor.disconnected_clients.length).to eq 1
      end

      it 'remove the client 2 from the connected client list' do
        line = ClientLogLine.new(disconnect_line)
        game_processor.process_client(line)

        expect(game_processor.connected_clients.length).to eq 0
      end
    end

    context 'when client connect, disconnect and connect' do
      before do
        line_disco = ClientLogLine.new(disconnect_line)
        line_connect = ClientLogLine.new(connect_line)
        game_processor.process_client(line_disco)
        game_processor.process_client(line_connect)
      end

      it 'add it again to the connected client list' do
        expect(game_processor.connected_clients.length).to eq 1
      end

      it 'remove the client 2 from the disconnected client list' do
        # TODO: this depends fo the name of the player, if is the same name its ok go to the disconnecte cliente a
        # and pop it out, but if the name is not on the disconnected list if another player, so ...
        # this needs to be validated on the userinfochangeevent
      end
    end

    context 'when ClientUserinfoChanged' do
      it 'initialize the name if there is no name' do
        line = ClientLogLine.new(user_info_change)

        game_processor.process_client(line)

        expect(game_processor.connected_clients.first.name).to eq 'Oootsimo'
      end

      it 'and process the same name twice, leave the same name' do
        line = ClientLogLine.new(user_info_change)

        game_processor.process_client(line)
        game_processor.process_client(line)

        expect(game_processor.connected_clients.first.name).to eq 'Oootsimo'
      end

      it 'from a disconnected client, pop it from the disconnected list' do
        game_processor = reconnect_name_change

        expect(game_processor.find_disconnected_client(name: 'Dono da Bola')).to be nil
      end

      it 'from a disconnected client, put it back on the connected list' do
        game_processor = reconnect_name_change

        expect(game_processor.find_connected_client(name: 'Dono da Bola')).not_to be nil
      end
    end

    it 'begin on true when ClientBegin' do
      # TODO: delete looks like is not needed
      # line = ClientLogLine.new(begin_line)

      # game_processor.process_client(line)

      # expect(game_processor.players.first.begin?).to eq true
    end
  end

  describe '#players' do
    it 'return the a list of connected and disconnected players'
  end

  describe '#add_kill' do
    context 'when player Kill another player' do
      let(:game_processor) do
        game_processor = described_class.new
        line = LogLine.new(kill_line)
        game_processor.add_kill(line)
        game_processor
      end

      it 'increase the total kills by one' do
        expect(game_processor.total_kills).to eq 1
      end

      it 'increase the kills of the player Isgalamido by one' do
        game_processor.add_kill(LogLine.new(kill_line))

        expect(game_processor.kills_scoreboard['Isgalamido']).to eq 2
      end
    end
  end

  context 'when the <world> kill player' do
    let(:world_kill_line) { ' 22:06 Kill: 2 3 7: <world> killed Mocinha by MOD_ROCKET_SPLASH' }

    let(:game_processor) do
      game_processor = described_class.new
      line = LogLine.new(world_kill_line)
      game_processor.add_kill(line)
      game_processor
    end

    it 'increase the total kills by one' do
      expect(game_processor.total_kills).to eq 1
    end

    it 'decrease the kills of the player Mocinha by one' do
      expect(game_processor.kills_scoreboard['Mocinha']).to eq(-1)
    end

    it 'not appear in the scoreboard' do
      expect(game_processor.kills_scoreboard['world']).to be nil
    end
  end

  context 'when player kill itself' do
    let(:world_kill_line) { '  1:05 Kill: 8 8 13: Isgalamido killed Isgalamido by MOD_BFG_SPLASH' }

    let(:game_processor) do
      game_processor = described_class.new
      line = LogLine.new(world_kill_line)
      game_processor.add_kill(line)
      game_processor
    end

    it 'increase the total kills by one' do
      expect(game_processor.total_kills).to eq 1
    end

    it 'death player losses -1 kill' do
      expect(game_processor.kills_scoreboard['Isgalamido']).to eq(-1)
    end
  end

  context 'when invalid kill line' do
    let(:not_kill_line) { ' 20:40 Item: 2 weapon_rocketlauncher' }
    let(:game_processor) do
      game_processor = described_class.new
      line = LogLine.new(not_kill_line)
      game_processor.add_kill(line)
      game_processor
    end

    it 'do not increase the total kills' do
      expect(game_processor.total_kills).to eq 0
    end

    it 'do not add anything in the scoreboard' do
      expect(game_processor.kills_scoreboard).to be_empty
    end
  end
end
