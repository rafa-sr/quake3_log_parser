# frozen_string_literal: true

describe Client do
  subject(:client) { described_class.new(id: 1, name: 'foo') }

  describe '#begin?' do
    it 'return true if client begun' do
      client.begin_state = true

      expect(client.begin?).to be true
    end

    it 'return false if client not begun' do
      client.begin_state = false

      expect(client.begin?).to be false
    end
  end
end
