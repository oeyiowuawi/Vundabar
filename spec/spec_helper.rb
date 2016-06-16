$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path("../../spec", __FILE__)
APP_ROOT = __dir__ + "/todolist"
require 'vundabar'
require "todolist/config/application.rb"
require 'rspec'
require 'rack/test'
# require "support/base_model_helper"
# require "support/test_seed"

RSpec.configure do |conf|
  conf.include Rack::Test::Methods

  conf.include FactoryGirl::Syntax::Methods

  conf.before(:suite) do
    FactoryGirl.find_definitions
  end
end

RSpec.shared_context type: :feature do
  require "capybara/rspec"
  before(:all) do
    app = Rack::Builder.parse_file(
      "#{__dir__}/todolist/config.ru"
    ).first
    Capybara.app = app
  end
end
