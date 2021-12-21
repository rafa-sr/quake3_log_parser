# frozen_string_literal: true

require 'simplecov'
require 'bundler'

SimpleCov.start do
  add_group 'Lib', 'lib'
  add_filter 'config'
  add_filter 'vendor'
  add_filter 'spec'
  minimum_coverage 90
end

ENV['ENV'] = 'test'

require File.expand_path('../../lib/boot.rb', __FILE__)

RSpec.configure do |conf|
  conf.order = :random
  conf.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end

  conf.after :suite do
    unless ENV['TEST_LINTER_OFF'] == 'true'
      puts ''
      rubocop_command = 'bundle exec rubocop'
      raise 'RuboCop Errors' unless system rubocop_command
    end
  end
end
