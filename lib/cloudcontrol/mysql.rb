module Cloudcontrol
  ADDON_KEYS = {  # NOTE addons MySQLS and MySQLD
    'database' => %w[ MYSQLD_DATABASE MYSQLS_DATABASE ],
    'host' => %w[ MYSQLD_HOST MYSQLS_HOSTNAME ],
    'port' => %w[ MYSQLD_PORT MYSQLS_PORT ],
    'username' => %w[ MYSQLD_USER MYSQLS_USERNAME ],
    'password' => %w[ MYSQLD_PASSWORD MYSQLS_PASSWORD ],
  }

  def self.configure_mysql(config, rails_env)
    config[rails_env].each do |key, value|
      if value.nil?
        new_value = ADDON_KEYS[key].reduce(nil) { |acc, e| acc ||= ENV[e] }
        raise "No enviroment variable for key '#{key}' found" if new_value.nil?
        new_value = new_value.to_i if key == 'port'

        config[rails_env][key] = new_value
      end
    end

    return config
  end
end
