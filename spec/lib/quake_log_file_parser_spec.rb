# frozen_string_literal: true

describe QuakeLogFileParser do
  let(:file_parser) { described_class.new }

  describe '#parse' do
    it 'split the log file in matches by (InitGame)' do
      games = 0

      File.foreach(File.join(ROOT, 'spec/fixture/qgames.log')) do |line|
        file_parser.parse line
        games += 1 if LogLine.new(line).init_game?
      end

      expect(file_parser.games_report.length).to eq games
    end
  end

  describe '#report' do
    before do
      File.foreach(File.join(ROOT, 'spec/fixture/qgames.log')) do |line|
        file_parser.parse line
      end
    end

    it 'print all the matches (21)' do
      expect(file_parser.games_report.length).to eq 21
    end
  end

  describe '#start_match' do
    before do
      file_parser.start_match
    end

    it 'put active_match on true' do
      expect(file_parser.active_match).to be true
    end

    it 'create new game_parser instance' do
      old_instance = file_parser.game_parser
      file_parser.start_match

      expect(file_parser.game_parser).not_to be old_instance
    end
  end

  describe '#finish_match' do
    before do
      match = { total_kills: 99,
                players:     %w[Maluquinho Ronaldinho],
                kills:       { Maluquinho: 0, Ronaldinho: 99 } }
      death_report = { kills_by_means: { MOD_SHOTGUN: 10 } }
      game_parser = instance_double 'GameParser'
      allow(GameParser).to receive(:new).and_return game_parser
      file_parser.start_match

      allow(game_parser).to receive(:print).and_return(match)
      allow(game_parser).to receive(:print_death_causes).and_return(death_report)
      file_parser.finish_match
    end

    it 'put active_match on false' do
      expect(file_parser.active_match).to be false
    end

    it 'append the match stats to the matches report array' do
      expect(file_parser.games_report.first).to include :game_1
    end

    it 'append the match death causes to the death causes report array' do
      expect(file_parser.deaths_report.first).to include :'game-1'
    end
  end
end
