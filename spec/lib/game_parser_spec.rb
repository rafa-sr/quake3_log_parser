# frozen_string_literal: true

describe GameParser do
  include_context 'when log lines'
  include_context 'when game processor'
  let(:results) do
    [{ score: 20, client: 3, name: 'Isgalamido' },
     { score: 14, client: 2, name: 'Oootsimo' },
     { score: 12, client: 4, name: 'Zeh' },
     { score: 8, client: 7, name: 'Assasinu Credi' },
     { score: -1, client: 5, name: 'Dono da Bola' },
     { score: -4, client: 6, name: 'Mal' }]
  end

  let(:total_kills) { 89 }

  context 'when process entire match' do
    let(:game_parser) { described_class.new }

    let(:kills_result) do
      kills_result = {}
      results.each do |key|
        kills_result.merge!({ key[:name] => key[:score] })
      end
      kills_result
    end

    let(:result_names) do
      results.map { |key| key[:name] }
    end

    let(:result_id) do
      results.map { |key| key[:client].to_s }
    end

    before do
      File.foreach(File.join(ROOT, 'spec/fixture/qgame.log')) do |line|
        game_parser.process(LogLine.new(line))
      end
    end

    describe '#players' do
      it 'return the name of all players' do
        expect(game_parser.players.map(&:name)).to match_array result_names
      end

      it 'return the id of all players' do
        expect(game_parser.players.map(&:id)).to match_array result_id
      end
    end

    describe '#total_kills' do
      it 'return all the kills' do
        expect(game_parser.total_kills).to eq total_kills
      end
    end

    describe '#players_name' do
      it 'return the name of all players' do
        expect(game_parser.players_name).to match_array result_names
      end
    end

    describe '#kills' do
      it 'return hash with player as a key and kills as a value' do
        expect(game_parser.kills).to eq kills_result
      end
    end

    describe '#print' do
      it 'return hash that include {kill:} as a key and with player as a child keys and kills number as a value' do
        expect(game_parser.print[:kills]).to eq kills_result
      end

      it 'return hash that include {players:} as a key and an array with the name of the players as a value' do
        expect(game_parser.print[:players]).to match_array result_names
      end

      it 'return hash that include {total_kills:} as a key and the total of kills as a value' do
        expect(game_parser.print[:total_kills]).to eq total_kills
      end

      it 'return hash that include {ranking:} as a key and the total of kills as a value' do
        expect(game_parser.print[:ranking]).to match_array results
      end
    end

    describe '#ranking' do
      it 'return a list ordered by the score in descendant way that include (score: client: name:) has a keys' do
        expect(game_parser.ranking).to eq results
      end
    end
  end
end
