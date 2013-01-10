require 'erb'

require 'cloudcontrol/cloudcontrol'

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
