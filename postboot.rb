module Cloudcontrol
  class Application < Rails::Application

    def config.database_configuration
      # detect rails environment, otherwise set it to development
      rails_env = ENV['RAILS_ENV'] || 'development'

      config = super

      # set creds for the different adapters
      case config[rails_env]['adapter']
        when 'mysql2' # MySQLS and MySQLD
          config[rails_env].each do |key, value|
            if value === nil # get value from cctrl ENV if nil
              if key === 'username' # auto match breaks on username so we need to look for it manually
                config[rails_env][key] = ENV["MYSQLD_USER"] || ENV["MYSQLS_USER"] || nil
              else
                config[rails_env][key] = ENV["MYSQLD_#{key.upcase}"] || ENV["MYSQLS_#{key.upcase}"] || nil
              end
            end
          end

        when 'postgresql' # postgres
          config[rails_env].each do |key, value|
            if value === nil && ENV["ELEPHANTSQL_URL"] # get value from cctrl ENV if nil and elephantsql added
              elephant_uri = URI.parse(ENV["ELEPHANTSQL_URL"])
              if key === 'database'
                config[rails_env][key] = elephant_uri.path[1..-1]
              elsif key === 'username'
                config[rails_env][key] = elephant_uri.user
              elsif key === 'password'
                config[rails_env][key] = elephant_uri.password
              elsif key === 'host'
                config[rails_env][key] = elephant_uri.host
              elsif key === 'port'
                config[rails_env][key] = elephant_uri.port
              end
            end
          end
      end
      return config
    end
  end
end