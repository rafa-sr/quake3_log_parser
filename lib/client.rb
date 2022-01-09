# frozen_string_literal: true

class Client
  attr_accessor :id, :name, :begin_state, :kills

  def initialize(id: nil, name: nil)
    @id = id
    @name = name
    @kills = 0
  end

  def begin?
    !!begin_state
  end
end
