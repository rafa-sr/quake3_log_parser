# frozen_string_literal: true

require 'rubygems'
require 'fileutils'
require 'bundler/setup'

require 'json'
require 'bundler'
Bundler.require :default
require_all 'lib/**.rb'
