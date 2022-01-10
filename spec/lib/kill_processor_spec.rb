# frozen_string_literal: true

describe KillProcessor do
  include_context 'when log lines'
  include_context 'when game processor'

  describe '#add_kill' do
    context 'when player Kill another player' do
      before do
        client_2_begun
        client_3_begun
      end

      it 'increase the total kills by one' do
        game_processor.process(LogLine.new(kill2_line))

        expect(game_processor.total_kills).to eq 1
      end

      it 'increase the kills of the player 2 by one' do
        kills = game_processor.players.first.kills

        game_processor.process(LogLine.new(kill2_line))

        expect(game_processor.players.first.kills).to eq kills + 1
      end
    end
  end

  context 'when the <world> kill player 2' do
    before do
      client_2_begun
    end

    it 'increase the total kills by one' do
      game_processor.process(LogLine.new(kill2_world_line))

      expect(game_processor.total_kills).to eq 1
    end

    it 'decrease the kills of the player 2 by one' do
      kills = game_processor.players.first.kills

      game_processor.process(LogLine.new(kill2_world_line))

      expect(game_processor.players.first.kills).to eq kills - 1
    end

    it 'not appear in the player list' do
      game_processor.players.each { |player| expect(player.name).not_to eq described_class::WORLD }
    end
  end

  context 'when player kill itself' do
    let(:world_kill_line) { '  1:05 Kill: 8 8 13: Isgalamido killed Isgalamido by MOD_BFG_SPLASH' }

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
