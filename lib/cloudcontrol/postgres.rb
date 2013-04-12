module Cloudcontrol
  def self.configure_postgres(config, rails_env)  # NOTE addon ElephantSQL
    if ENV['ELEPHANTSQL_URL']
      elephant_uri = URI.parse ENV['ELEPHANTSQL_URL']
    else
      raise "No enviroment variable for PostgreSQL found"
    end

    config[rails_env].each do |key, value|
      if value.nil?
        case key
          when 'database'
            config[rails_env][key] = elephant_uri.path[1 .. -1]
          when 'username'
            config[rails_env][key] = elephant_uri.user
          when 'password'
            config[rails_env][key] = elephant_uri.password
          when 'host'
            config[rails_env][key] = elephant_uri.host
          when 'port'
            config[rails_env][key] = elephant_uri.port
        end
      end
    end

    return config
  end
end
