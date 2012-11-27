module MyApp
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
      end

      return config
    end
  end
end