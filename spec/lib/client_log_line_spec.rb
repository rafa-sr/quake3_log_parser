# frozen_string_literal: true

describe ClientLogLine do
  include_context 'when log lines'

  describe '#connect?' do
    it 'return true when is client connect event' do
      client_log = described_class.new(connect_line)

      expect(client_log.connect?).to be true
    end

    it 'return false when is not client connect event' do
      not_client_log = described_class.new(item_line)

      expect(not_client_log.connect?).to be false
    end
  end

  describe '#name_changed?' do
    it 'return true when is client info change event' do
      client_log = described_class.new(name_line)

      expect(client_log.name_changed?).to be true
    end

    it 'return false when is not client connect event' do
      not_client_log = described_class.new(item_line)

      expect(not_client_log.name_changed?).to be false
    end
  end

  describe '#begin?' do
    it 'return true when is clientbegin event' do
      client_log = described_class.new(begin_line)

      expect(client_log.begin?).to be true
    end

    it 'return false when is not client connect event' do
      not_client_log = described_class.new(item_line)

      expect(not_client_log.begin?).to be false
    end
  end

  describe '#id' do
    it 'return the id when a connect' do
      client_log = described_class.new(connect_line)

      expect(client_log.id).to eq '2'
    end

    it 'return the id when a info changed' do
      client_log = described_class.new(name_line)

      expect(client_log.id).to eq '2'
    end

    it 'return the id when a beging' do
      client_log = described_class.new(begin_line)

      expect(client_log.id).to eq '2'
    end
  end
end
