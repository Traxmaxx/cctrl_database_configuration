require 'cloudcontrol/mysql'
require 'cloudcontrol/postgres'

module Cloudcontrol
  def self.reconfigure_database_configuration(config)
    rails_env = ENV['RAILS_ENV'] || 'development'

    # set creds for the different adapters
    case config[rails_env]['adapter']
      when 'mysql2'
        Cloudcontrol::configure_mysql config, rails_env
      when 'postgresql'
        Cloudcontrol::configure_postgres config, rails_env
    end
  end
end
