# frozen_string_literal: true

require 'rubygems'
require 'fileutils'
require 'bundler/setup'

require 'json'
require 'bundler'
Bundler.require :default
require_all 'lib/log_line.rb'
require_all 'lib'
