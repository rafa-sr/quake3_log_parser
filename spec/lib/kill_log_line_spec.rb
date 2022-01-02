# frozen_string_literal: true

describe KillLogLine do
  include_context 'when log lines'

  describe '#killer_id' do
    it 'return id of killer player' do
      kill_log_line = described_class.new(kill_line2)

      expect(kill_log_line.killer_id).to eq '2'
    end

    it 'return 1022 when is killed by <world>' do
      kill_log_line = described_class.new(kill_world_line)

      expect(kill_log_line.killer_id).to eq described_class::WORLD_ID
    end
  end

  describe '#death_player' do
    it 'return id of the death player' do
      kill_log_line = described_class.new(kill_line2)

      expect(kill_log_line.death_id).to eq '3'
    end
  end

  describe '#death_cause' do
    it 'return the last word (MOD_ROCKET) in the log line' do
      kill_log_line = described_class.new(kill_line2)

      expect(kill_log_line.death_cause).to eq MeansOfDeath::MOD_ROCKET
    end
  end
end
