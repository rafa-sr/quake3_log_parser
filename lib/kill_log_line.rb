# frozen_string_literal: true

class KillLogLine < LogLine
  def killer_player
    before_killed_tokens = @tokens.drop(BEFORE_KILLER_PLAYER_INDEX)
    parse_player_name(before_killed_tokens, KILLED)
  end

  def death_player
    after_killed_index = find_killed_word_index + 1
    after_killed_tokens = @tokens.drop(after_killed_index)
    parse_player_name(after_killed_tokens, BY)
  end

  def find_killed_word_index
    @tokens.each_with_index { |token, index| return index if token == KILLED }
  end

  def death_cause
    @death_cause ||= @tokens.last
  end
end
