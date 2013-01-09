require 'erb'

require 'cloudcontrol/mysql'
require 'cloudcontrol/postgres'

module Cloudcontrol
  def self.reconfigure_database_configuration(config)
    rails_env = ENV['RAILS_ENV'] || 'development'

    # set creds for the different adapters
    case config[rails_env]['adapter']
      when 'mysql2'  # addons MySQLS and MySQLD
        Cloudcontrol::configure_mysql config, rails_env
      when 'postgresql'  # addon ElephantSQL
        Cloudcontrol::configure_postgres config, rails_env
    end
  end
end

module Rails
  class Application
    class Configuration < ::Rails::Engine::Configuration
      def database_configuration
        config = YAML::load ERB.new(IO.read(paths['config/database'].first)).result

        return Cloudcontrol::reconfigure_database_configuration config
      end
    end
  end
end