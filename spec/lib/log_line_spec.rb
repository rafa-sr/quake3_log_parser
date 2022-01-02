# frozen_string_literal: true

require 'spec_helper'

describe LogLine do
  let(:kill_line) { '13:55 Kill: 3 4 6: Oootsimo killed Dono da Bola by MOD_ROCKET' }

  include_context 'when log lines'
  describe '#event' do
    it 'return the Kill event that trigger the log' do
      log_line = described_class.new(kill_line)

      expect(log_line.event).to eq 'Kill'
    end

    it 'return nil when there is event' do
      line = '  2:33 ------------------------------------------------------------'
      log_line = described_class.new(line)

      expect(log_line.event).to eq nil
    end
  end

  describe '#valid_kill_line?' do
    it 'return true when the event of the log is a kill' do
      log_line = described_class.new(kill_line)

      expect(log_line.valid_kill_line?).to be true
    end

    it 'return false when the event of the log is not a event' do
      line = '  0:00 ------------------------------------------------------------'
      log_line = described_class.new(line)

      expect(log_line.valid_kill_line?).to be false
    end

    it 'return false when the event of the log is not a kill' do
      line = ' 20:34 ClientConnect: 2'
      log_line = described_class.new(line)

      expect(log_line.valid_kill_line?).to be false
    end
  end

  describe '#client_line?' do
    it 'return true when the event of the log is a client event' do
      log_line = described_class.new(client_connect_line)

      expect(log_line.client_line?).to be true
    end

    it 'return false when the event of the log is not even a event' do
      log_line = described_class.new(item_line)

      expect(log_line.client_line?).to be false
    end
  end

  describe '#killer_player' do
    it 'return name of the player before the killed word' do
      log_line = described_class.new(kill_line)

      expect(log_line.killer_player).to eq 'Oootsimo'
    end

    it 'return name of the player with white spaces before the killed word' do
      kill_line = '  2:11 Kill: 2 4 6: Dono da Bola killed Zeh by MOD_ROCKET'
      log_line = described_class.new(kill_line)

      expect(log_line.killer_player).to eq 'Dono da Bola'
    end

    it 'return world when is killed by <world>' do
      kill_line = ' 21:42 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT'
      log_line = described_class.new(kill_line)

      expect(log_line.killer_player).to eq 'world'
    end
  end

  describe '#death_player' do
    it 'return name of the player with white spaces after the killed word' do
      log_line = described_class.new(kill_line)

      expect(log_line.death_player).to eq 'Dono da Bola'
    end

    it 'return name of the player after the killed word' do
      kill_line = '  2:11 Kill: 2 4 6: Dono da Bola killed Zeh by MOD_ROCKET'
      log_line = described_class.new(kill_line)

      expect(log_line.death_player).to eq 'Zeh'
    end
  end

  describe '#death_cause' do
    it 'return the last word (MOD_ROCKET) in the log line' do
      log_line = described_class.new(kill_line)

      expect(log_line.death_cause).to eq 'MOD_ROCKET'
    end
  end
end
