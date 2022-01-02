# frozen_string_literal: true

require 'spec_helper'

describe LogLine do
  include_context 'when log lines'
  describe '#event' do
    it 'return the Kill event that trigger the log' do
      log_line = described_class.new(kill_line2)

      expect(log_line.event).to eq 'Kill'
    end

    it 'return nil when there is event' do
      line = '  2:33 ------------------------------------------------------------'
      log_line = described_class.new(line)

      expect(log_line.event).to eq nil
    end
  end

  describe '#kill_line?' do
    it 'return true when the event of the log is a kill' do
      log_line = described_class.new(kill_line2)

      expect(log_line.kill_line?).to be true
    end

    it 'return false when the event of the log is not a event' do
      line = '  0:00 ------------------------------------------------------------'
      log_line = described_class.new(line)

      expect(log_line.kill_line?).to be false
    end

    it 'return false when the event of the log is not a kill' do
      line = ' 20:34 ClientConnect: 2'
      log_line = described_class.new(line)

      expect(log_line.kill_line?).to be false
    end
  end

  describe '#client_line?' do
    it 'return true when the event of the log is a client event' do
      log_line = described_class.new(connect_line)

      expect(log_line.client_line?).to be true
    end

    it 'return false when the event of the log is not even a event' do
      log_line = described_class.new(item_line)

      expect(log_line.client_line?).to be false
    end
  end
end
