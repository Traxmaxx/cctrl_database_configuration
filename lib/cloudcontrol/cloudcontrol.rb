require 'cloudcontrol/mysql'
require 'cloudcontrol/postgres'

module Cloudcontrol
  CONFIGURE_METHODS = %w[ configure_mysql configure_postgres ]  # NOTE
  CONFIGURE_ADAPTERS = %w[ mysql2 postgresql ]  # NOTE

  def self.update_with_defaults(config, rails_env)
    %W[ host port database username password ].each do |key|
      config[rails_env][key] = nil
    end
  end

  def self.reconfigure_database_configuration(config)
    rails_env = ENV['RAILS_ENV'] || 'development'

    update_with_defaults(config, rails_env) if config[rails_env].size == 1

    [ CONFIGURE_METHODS, CONFIGURE_ADAPTERS ].transpose.each do |m, a|
      if config[rails_env]['adapter'] == a
        return Cloudcontrol.send m, config, rails_env
      end
    end

  end

  def self.generate_database_configuration()
    rails_env = ENV['RAILS_ENV'] || 'development'

    if rails_env == 'development'
      err_msg = "Database configuration can't be generated for development environment"
      puts err_msg
      raise err_msg
    end

    return select_configuration rails_env
  end

  def self.select_configuration(rails_env)
    config = { rails_env => { 'adapter' => nil } }
    update_with_defaults config, rails_env

    [ CONFIGURE_METHODS, CONFIGURE_ADAPTERS ].transpose.each do |m, a|
      config[rails_env]['adapter'] = a
      return Cloudcontrol.send m, config, rails_env rescue nil
    end

    err_msg = "Automatic database configuration failed. Check you addon settings and environment variables."
    puts err_msg
    raise err_msg
  end
end
