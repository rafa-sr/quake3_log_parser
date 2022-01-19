# frozen_string_literal: true

describe KillProcessor do
  include_context 'when log lines'
  let(:client_processor) { ClientProcessor.new }
  let(:kill_processor) { described_class.new(client_processor) }
  let(:killer_id) { 0 }

  before do
    begun2_lines.each do |line|
      line = ClientLogLine.new(line)
      client_processor.process(line)
    end

    begun3_lines.each do |line|
      line = ClientLogLine.new(line)
      client_processor.process(line)
    end
  end

  describe '#add_kill' do
    context 'when player Kill another player' do
      let(:kill_log_line) { KillLogLine.new(kill2_line) }

      before do
        kill_processor.add_kill(kill_log_line)
      end

      it 'increase the total kills by one' do
        expect(kill_processor.total_kills).to eq 1
      end

      it 'increase the kills of the player by one' do
        player_score = ClientHelper.client_kills(id:               kill_log_line.id,
                                                 client_processor: client_processor)
        expect(player_score).to eq 1
      end
    end
  end

  context 'when the <world> kill player 2' do
    let(:kill_world_line) { KillLogLine.new(kill2_world_line) }

    before do
      kill_processor.process(kill_world_line)
    end

    it 'increase the total kills by one' do
      expect(kill_processor.total_kills).to eq 1
    end

    it 'decrease the kills of the player 2 by one' do
      player_score = ClientHelper.client_kills(id:               kill_world_line.death_id,
                                               client_processor: client_processor)

      expect(player_score).to eq(-1)
    end

    it 'not appear in the connected client list' do
      client_processor.connected_clients.each { |player| expect(player.name).not_to eq KillLogLine::WORLD }
    end
  end

  context 'when player kill itself' do
    let(:kill_self_line) { KillLogLine.new(self3_kill_line) }

    before do
      kill_processor.process(kill_self_line)
    end

    it 'increase the total kills by one' do
      expect(kill_processor.total_kills).to eq 1
    end

    it 'player losses -1 kill' do
      player_score = ClientHelper.client_kills(id:               kill_self_line.killer_id,
                                               client_processor: client_processor)
      expect(player_score).to eq(-1)
    end
  end
end
