require 'erb'

require 'cloudcontrol/cloudcontrol'

module Rails
  class Application
    class Configuration < ::Rails::Engine::Configuration
      def database_configuration
        begin
          config = YAML::load ERB.new(IO.read(paths['config/database'].first)).result
        rescue
          config = Cloudcontrol::generate_database_configuration
          puts <<MSG
Looks like you don't have the database.yml configuration file.
The following database configuration was auto-generated for you:
#{ config.to_yaml }
MSG
        end

        return Cloudcontrol::reconfigure_database_configuration config
      end
    end
  end
end
