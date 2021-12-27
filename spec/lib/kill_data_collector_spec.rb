# frozen_string_literal: true

describe KillDataCollector do
  let(:kill_line) { ' 22:06 Kill: 2 3 7: Isgalamido killed Mocinha by MOD_ROCKET_SPLASH' }

  describe '#add' do
    context 'when player kill another player' do
      let(:kill_data_collector) do
        kill_data_collector = described_class.new
        line = LogLine.new(kill_line)
        kill_data_collector.add(line)
        kill_data_collector
      end

      it 'increase the total kills by one' do
        expect(kill_data_collector.total_kills).to eq 1
      end

      it 'increase the kills of the player Isgalamido by one' do
        kill_data_collector.add(LogLine.new(kill_line))

        expect(kill_data_collector.kills_scoreboard['Isgalamido']).to eq 2
      end
    end
  end

  context 'when the killer is the <world>' do
    let(:world_kill_line) { ' 22:06 Kill: 2 3 7: <world> killed Mocinha by MOD_ROCKET_SPLASH' }

    let(:kill_data_collector) do
      kill_data_collector = described_class.new
      line = LogLine.new(world_kill_line)
      kill_data_collector.add(line)
      kill_data_collector
    end

    it 'increase the total kills by one' do
      expect(kill_data_collector.total_kills).to eq 1
    end

    it 'decrease the kills of the player Mocinha by one' do
      expect(kill_data_collector.kills_scoreboard['Mocinha']).to eq(-1)
    end

    it 'not appear in the scoreboard' do
      expect(kill_data_collector.kills_scoreboard['world']).to be nil
    end
  end

  context 'when the death player is the killer (suicide)' do
    let(:world_kill_line) { '  1:05 Kill: 8 8 13: Isgalamido killed Isgalamido by MOD_BFG_SPLASH' }

    let(:kill_data_collector) do
      kill_data_collector = described_class.new
      line = LogLine.new(world_kill_line)
      kill_data_collector.add(line)
      kill_data_collector
    end

    it 'increase the total kills by one' do
      expect(kill_data_collector.total_kills).to eq 1
    end

    it 'death player losses -1 kill' do
      expect(kill_data_collector.kills_scoreboard['Isgalamido']).to eq(-1)
    end
  end

  context 'when invalid kill line' do
    let(:not_kill_line) { ' 20:40 Item: 2 weapon_rocketlauncher' }
    let(:kill_data_collector) do
      kill_data_collector = described_class.new
      line = LogLine.new(not_kill_line)
      kill_data_collector.add(line)
      kill_data_collector
    end

    it 'do not increase the total kills' do
      expect(kill_data_collector.total_kills).to eq 0
    end

    it 'do not add anything in the scoreboard' do
      expect(kill_data_collector.kills_scoreboard).to be_empty
    end
  end
end
