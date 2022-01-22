# frozen_string_literal: true

class KillLogLine < LogLine
  WORLD_ID = '1022'
  WORLD = 'world'

  def killer_id
    id
  end

  def death_id
    @death_id ||= @tokens[4]
  end

  def death_cause
    @death_cause ||= @tokens.last
  end
end
