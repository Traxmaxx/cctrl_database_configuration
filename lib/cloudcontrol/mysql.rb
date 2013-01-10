module Cloudcontrol
  def self.configure_mysql(config, rails_env)  # NOTE addons MySQLS and MySQLD
    config[rails_env].each do |key, value|
      if value.nil?
        if key == 'username'  # NOTE auto match breaks on username so we need to look for it manually
          config[rails_env][key] = ENV['MYSQLD_USER'] || ENV['MYSQLS_USER'] || nil
        else
          config[rails_env][key] = ENV["MYSQLD_#{ key.upcase }"] || ENV["MYSQLS_#{ key.upcase }"] || nil
        end
      end
    end

    return config
  end
end
