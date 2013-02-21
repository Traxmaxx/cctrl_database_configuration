require 'cloudcontrol/mysql'
require 'cloudcontrol/postgres'

module Cloudcontrol
  def self.update_with_defaults(config, rails_env)
    %W[ host port database username password ].each do |key|
      config[rails_env][key] = nil
    end
  end

  def self.reconfigure_database_configuration(config)
    rails_env = ENV['RAILS_ENV'] || 'development'

    update_with_defaults(config, rails_env) if config[rails_env].size == 1

    # set creds for the different adapters
    case config[rails_env]['adapter']
      when 'mysql2'
        Cloudcontrol::configure_mysql config, rails_env
      when 'postgresql'
        Cloudcontrol::configure_postgres config, rails_env
    end
  end
end
