require 'erb'
require 'uri'
require 'yaml'

require 'spec_helper'
require 'cloudcontrol/cloudcontrol'

describe "Cloudcontrol" do
  let(:db_config_dev) { [ adapter, 'env', 42, 'env', 'env', 'env' ] }
  let(:db_config_prod) { [ adapter, 'env', 42, 'env', 'env', 'env' ] }

  let(:database_yml) do
    yml = <<END
development:
  adapter: %s
  encoding: utf8
  reconnect: false
  pool: 5
  host: %s
  port: %s
  database: %s
  username: %s
  password: %s
production:
  adapter: %s
  encoding: utf8
  reconnect: false
  pool: 5
  host: %s
  port: %s
  database: %s
  username: %s
  password: %s
END

    yml % db_config
end

  let(:db_config) { db_config_dev + db_config_prod }

  let(:config) do
    IO.stub!(:read).and_return database_yml
    YAML::load ERB.new(IO.read('config/database')).result
  end

  let(:not_modified) do
    {
      "adapter" => adapter,
      "host" => 'env',
      "port" => 42,
      "database" => 'env',
      "username" => 'env',
      "password" => 'env',
    }
  end

  before do
    ENV = {
      'RAILS_ENV' => "production",
      'MYSQLS_HOST' => "env",
      'MYSQLS_PORT' => "42",
      'MYSQLS_DATABASE' => "env",
      'MYSQLS_USER' => "env",
      'MYSQLS_PASSWORD' => "env",
      'ELEPHANTSQL_URL' => 'postgres://env:env@env.env.env:42/env',
    }
  end

  describe "MySQL" do
    let(:adapter) { 'mysql2' }

    describe "without provided values" do
      let(:db_config_prod) { [ adapter ] + [ nil] * 5 }
      let(:expected_res) { not_modified }  # HACK

      it "should return proper value" do
        env = 'production'
        ENV["RAILS_ENV"] = env
        res = Cloudcontrol::reconfigure_database_configuration config
        res[env].should include(expected_res)
      end
    end

    describe "with partially provided values" do
      let(:expected_res) do
        {
          "adapter"=>adapter,
          "host"=>"host",
          "port"=>42,
          "database"=>"db",
          "username"=>"env",
          "password"=>"env"
        }
      end

      describe "for production" do
        let(:db_config_prod) { [ adapter, 'host', '42', 'db', nil, nil ] }

        it "should return proper value" do
          env = 'production'
          other_env = 'development'
          ENV["RAILS_ENV"] = env

          res = Cloudcontrol::reconfigure_database_configuration config
          res[env].should include(expected_res)
          res[other_env].should include(not_modified)
        end
      end

      describe "for development" do
        let(:db_config_dev) { [ adapter, 'host', '42', 'db', nil, nil ] }

        it "should return proper value" do
          env = 'development'
          other_env = 'production'
          ENV["RAILS_ENV"] = env

          res = Cloudcontrol::reconfigure_database_configuration config
          res[env].should include(expected_res)
          res[other_env].should include(not_modified)
        end
      end
    end

    describe "with fully provided values" do
      let(:db_config_prod) { [ adapter, 'host', '42', 'db', 'username', 'pass' ] }
      let(:expected_res) do
        {
          "adapter"=>adapter,
          "host"=>"host",
          "port"=>42,
          "database"=>"db",
          "username"=>"username",
          "password"=>"pass"
        }
      end

      it "should return proper value" do
        env = 'production'
        ENV["RAILS_ENV"] = env
        res = Cloudcontrol::reconfigure_database_configuration config
        res[env].should include(expected_res)
      end
    end
  end

  describe "PostgreSQL" do
    let(:adapter) { 'postgresql' }

    describe "without provided values" do
      let(:db_config_prod) { [ adapter ] + [ nil] * 5 }
      let(:expected_res) do
        {
          "adapter" => adapter,
          "host" => 'env.env.env',
          "port" => 42,
          "database" => 'env',
          "username" => 'env',
          "password" => 'env',
        }
      end

      it "should return proper value" do
        env = 'production'
        ENV["RAILS_ENV"] = env
        res = Cloudcontrol::reconfigure_database_configuration config
        res[env].should include(expected_res)
      end
    end

    describe "with partially provided values" do
      let(:expected_res) do
        {
          "adapter"=>adapter,
          "host"=>"host",
          "port"=>42,
          "database"=>"db",
          "username"=>"env",
          "password"=>"env"
        }
      end

      describe "for production" do
        let(:db_config_prod) { [ adapter, 'host', 42, 'db', nil, nil ] }

        it "should return proper value" do
          env = 'production'
          other_env = 'development'
          ENV["RAILS_ENV"] = env

          res = Cloudcontrol::reconfigure_database_configuration config
          res[env].should include(expected_res)
          res[other_env].should include(not_modified)
        end
      end

      describe "for development" do
        let(:db_config_dev) { [ adapter, 'host', 42, 'db', nil, nil ] }

        it "should return proper value" do
          env = 'development'
          other_env = 'production'
          ENV["RAILS_ENV"] = env

          res = Cloudcontrol::reconfigure_database_configuration config
          res[env].should include(expected_res)
          res[other_env].should include(not_modified)
        end
      end
    end

    describe "with fully provided values" do
      let(:db_config_prod) { [ adapter, 'host', 42, 'db', 'username', 'pass' ] }
      let(:expected_res) do
        {
          "adapter"=>adapter,
          "host"=>"host",
          "port"=>42,
          "database"=>"db",
          "username"=>"username",
          "password"=>"pass"
        }
      end

      it "should return proper value" do
        env = 'production'
        ENV["RAILS_ENV"] = env
        res = Cloudcontrol::reconfigure_database_configuration config
        res[env].should include(expected_res)
      end
    end
  end
end
