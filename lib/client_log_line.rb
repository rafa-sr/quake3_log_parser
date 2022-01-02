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
end
