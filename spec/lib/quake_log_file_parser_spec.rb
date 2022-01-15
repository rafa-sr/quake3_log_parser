# frozen_string_literal: true

describe QuakeLogFileParser do
  describe '#parse' do
    it 'split the log file in matches' do
      file_parser = described_class.new('spec/fixture/qgames.log')

      file_parser.parse

      expect(file_parser.matches.length).to eq 21
    end
  end
end
