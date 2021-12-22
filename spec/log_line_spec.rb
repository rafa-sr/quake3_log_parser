# frozen_string_literal: true

require 'spec_helper'

describe LogLine do
  let(:line) { '13:55 Kill: 3 4 6: Oootsimo killed Dono da Bola by MOD_ROCKET' }

  describe '#event' do
    it 'return the event that trigger the log' do
      log_line = described_class.new(line)

      expect(log_line.event).to eq 'Kill'
    end

    it 'return nil when there is event' do
      line = '  2:33 ------------------------------------------------------------'
      log_line = described_class.new(line)

      expect(log_line.event).to eq nil
    end
  end

  describe '#kill?' do
    it 'return true when the event of the log is a kill' do
      log_line = described_class.new(line)

      expect(log_line.kill?).to be true
    end

    it 'return false when the event of the log is not a event' do
      line = ' 26  0:00 ------------------------------------------------------------'
      log_line = described_class.new(line)

      expect(log_line.kill?).to be false
    end

    it 'return false when the event of the log is not a kill' do
      line = ' 20:34 ClientConnect: 2'
      log_line = described_class.new(line)

      expect(log_line.kill?).to be false
    end
  end

  describe '#killer' do
    it 'return name of the player before the killed word' do
      log_line = described_class.new(line)

      expect(log_line.killer).to eq 'Oootsimo'
    end

    it 'return name of the player with white spaces before the killed word' do
      line = '  2:11 Kill: 2 4 6: Dono da Bola killed Zeh by MOD_ROCKET'
      log_line = described_class.new(line)

      expect(log_line.killer).to eq 'Dono da Bola'
    end
  end
end
