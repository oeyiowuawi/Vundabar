$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path("../../spec", __FILE__)
require 'vundabar'
require "todolist/config/application.rb"
require 'rspec'
require 'rack/test'
require "support/test_seed"
require "support/base_model_helper"

ENV['RACK_ENV'] = 'test'
