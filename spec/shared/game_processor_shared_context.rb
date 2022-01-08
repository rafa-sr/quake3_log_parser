# frozen_string_literal: true

shared_context 'when game processor' do
  include_context 'when log lines'
  let(:client_2_begun) do
    game_processor = GameProcessor.new
    line = ClientLogLine.new(connect_line)
    game_processor.process_client(line)
    game_processor
  end

  let(:reconnect_name_change) do
    game_processor = GameProcessor.new
    name_change_array.each do |connect_line|
      line = ClientLogLine.new(connect_line)
      game_processor.process_client(line)
    end
    game_processor
  end

  let(:name_change_array) do
    ['16:36 ClientConnect: 3',
     '16:36 ClientUserinfoChanged: 3 n\Isgalamido\t\0\model\uriel/zael\hmodel\uriel/zael\g_redteam\\g_blueteam\\c1\5\c2\5\hc\100\w\0\l\0\tt\0\tl\0',
     '16:36 ClientBegin: 3',

     '16:36 ClientConnect: 5',
     '16:36 ClientUserinfoChanged: 5 n\Dono da Bola\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\95\w\0\l\0\tt\0\tl\0',
     '16:36 ClientBegin: 5',

     '17:42 ClientDisconnect: 3',

     '17:48 ClientDisconnect: 5',

     '18:00 ClientConnect: 3',
     '18:00 ClientUserinfoChanged: 3 n\Isgalamido\t\0\model\uriel/zael\hmodel\uriel/zael\g_redteam\\g_blueteam\\c1\5\c2\5\hc\100\w\0\l\0\tt\0\tl\0',
     '18:01 ClientUserinfoChanged: 3 n\Isgalamido\t\0\model\uriel/zael\hmodel\uriel/zael\g_redteam\\g_blueteam\\c1\5\c2\5\hc\100\w\0\l\0\tt\0\tl\0',
     '18:01 ClientBegin: 3',

     '18:29 ClientDisconnect: 3',

     '18:38 ClientConnect: 3',
     '18:38 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0',
     '18:40 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\95\w\0\l\0\tt\0\tl\0',
     '18:40 ClientBegin: 3']
  end
end
