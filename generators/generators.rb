require "thor"
module Vundabar
  class Generators < Thor
    include Thor::Actions
    attr_reader :app
    def self.source_root
      File.dirname(__FILE__) + "/templates"
    end

    desc "server", "Starts vundabar server"

    def server
      exec "rackup"
    end
    map %w(s, server) => "server"

    desc "new APP_NAME", "create the app boiler plate file structure"

    def new(app_name)
      @app = app_name.downcase
      say "creating your new app #{app}"
      empty_directory app.to_s
      empty_directory "#{app}/app"
      empty_directory "#{app}/app/controllers"
      empty_directory "#{app}/app/models"
      create_views_folders
      create_config_files
      empty_directory "#{app}/db"
      create_public_directory
      add_files_to_root_folders
    end

    desc "version", "displays the current version of the vundabar gem"

    def version
      Vundabar::VERSION
    end
    map %w(-v --version) => "version"
    private

    def create_views_folders
      empty_directory "#{app}/app/views/layouts"
      copy_file(
        "application.html.erb",
        "#{app}/app/views/layouts/application.html.erb"
      )
    end

    def create_config_files
      say "creating config folder"
      empty_directory "#{app}/config"
      copy_file "application.rb", "#{app}/config/application.rb"
      copy_file "routes.rb", "#{app}/config/routes.rb"
    end

    def create_public_directory
      empty_directory "#{app}/public"
      copy_file "invalid_route.html.erb", "#{app}/public/invalid_route.html.erb"
    end

    def add_files_to_root_folders
      copy_file "config.ru", "#{app}/config.ru"
      copy_file "Gemfile", "#{app}/Gemfile"
    end
  end
end
