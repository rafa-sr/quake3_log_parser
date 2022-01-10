# frozen_string_literal: true

class ClientLogLine < LogLine
  def connect?
    return true if event == LogLine::CLIENT_CONNECT

    false
  end

  def name_changed?
    return true if event == LogLine::CLIENT_NAME_CHANGED

    false
  end

  def begin?
    return true if event == LogLine::CLIENT_BEGIN

    false
  end

  def disconnect?
    return true if event == LogLine::CLIENT_DISCONNECT

    false
  end

  def name
    start = line.index('n\\') + 2
    finish = line.index('\\t') - 1
    @name ||= line[start..finish]
  end
end
