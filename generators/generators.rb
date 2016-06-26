require 'thor'

class Vundabar::Generators < Thor
  include Thor::Actions

  def self.source_root
      File.dirname(__FILE__)
  end

  desc "server", "Starts vundabar server"

  def server
    bundle exec rackup
  end
  map %w(s, server) => "server"
end
