# frozen_string_literal: true

describe KillProcessor do
  include_context 'when log lines'
  include_context 'when game processor'

  describe '#add_kill' do
    context 'when player Kill another player' do
      before do
        client_2_begun
        client_3_begun
        game_processor.process(LogLine.new(kill2_line))
      end

      it 'increase the total kills by one' do
        expect(game_processor.total_kills).to eq 1
      end

      it 'increase the kills of the player 2 by one' do
        expect(game_processor.players.first.kills).to eq 1
      end
    end
  end

  context 'when the <world> kill player 2' do
    before do
      client_2_begun
      game_processor.process(LogLine.new(kill2_world_line))
    end

    it 'increase the total kills by one' do
      expect(game_processor.total_kills).to eq 1
    end

    it 'decrease the kills of the player 2 by one' do
      expect(game_processor.players.first.kills).to eq(-1)
    end

    it 'not appear in the player list' do
      game_processor.players.each { |player| expect(player.name).not_to eq KillLogLine::WORLD }
    end
  end

  context 'when player kill itself' do
    before do
      client_3_begun
      game_processor.process(LogLine.new(self3_kill_line))
    end

    it 'increase the total kills by one' do
      expect(game_processor.total_kills).to eq 1
    end

    it 'death player losses -1 kill' do
      expect(game_processor.players.first.kills).to eq(-1)
    end
  end
end
