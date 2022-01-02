# frozen_string_literal: true

shared_context 'when log lines' do
  let(:connect_line) { ' 11:23 ClientConnect: 2' }
  let(:begin_line) { ' 11:23 ClientBegin: 2' }
  let(:item_line) { ' 11:23 Item: 2 ammo_rockets' }
  let(:name_line) do
    ' 11:23 ClientUserinfoChanged: 2 n\Oootsimo\t\0\model\razor/id\hmodel\razor/id\g_redteam\\g_blueteam\\c1\3\c2\5\hc\100\w\0\l\0\tt\0\tl\0'
  end
end
