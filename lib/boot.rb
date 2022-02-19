# frozen_string_literal: true

require 'bundler'
Bundler.require :default

require 'rubygems'
require 'fileutils'
require 'json'
require 'logger'
require 'optparse'
require 'securerandom'

require_all 'lib/log_line.rb'
require_all 'lib/processor.rb'
require_all 'lib'
