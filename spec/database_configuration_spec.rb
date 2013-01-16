require 'erb'
require 'uri'
require 'yaml'

require 'spec_helper'
require 'cloudcontrol/cloudcontrol'

shared_examples "a configuration test" do |env|
  it "should return proper value" do
    other_env = (env == 'production') ? 'development' : 'production'

    ENV["RAILS_ENV"] = env

    res = Cloudcontrol::reconfigure_database_configuration config
    res[env].should include(expected_res)
    res[other_env].should include(not_modified)
  end
end

shared_examples "a database" do |env_vars|
  let(:db_config_dev) { [ adapter, 'env.env.env', 42, 'env', 'env', 'env' ] }
  let(:db_config_prod) { [ adapter, 'env.env.env', 42, 'env', 'env', 'env' ] }
  let(:db_config) { db_config_dev + db_config_prod }

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

  let(:config) do
    IO.stub!(:read).and_return database_yml
    YAML::load ERB.new(IO.read('config/database')).result
  end

  let(:not_modified) do
    {
      "adapter" => adapter,
      "host" => 'env.env.env',
      "port" => 42,
      "database" => 'env',
      "username" => 'env',
      "password" => 'env',
    }
  end

  before do
    ENV = env_vars
  end

  describe "without provided values" do
    let(:expected_res) { not_modified }  # HACK
    let(:db_config_prod) { [ adapter ] + [ nil] * 5 }

    it_should_behave_like "a configuration test", 'production'
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
      it_should_behave_like "a configuration test", 'production'
    end

    describe "for development" do
      let(:db_config_dev) { [ adapter, 'host', 42, 'db', nil, nil ] }
      it_should_behave_like "a configuration test", 'development'
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

    it_should_behave_like "a configuration test", 'production'
  end
end


describe "Cloudcontrol" do
  describe "MySQL" do
    let(:adapter) { 'mysql2' }

    describe "with MySQLs addon" do
      it_should_behave_like "a database", {
        'RAILS_ENV' => "production",
        'MYSQLS_HOSTNAME' => "env.env.env",
        'MYSQLS_PORT' => "42",
        'MYSQLS_DATABASE' => "env",
        'MYSQLS_USERNAME' => "env",
        'MYSQLS_PASSWORD' => "env",
      }
    end

    describe "with MySQLd addon" do
      it_should_behave_like "a database", {
        'RAILS_ENV' => "production",
        'MYSQLD_HOST' => "env.env.env",
        'MYSQLD_PORT' => "42",
        'MYSQLD_DATABASE' => "env",
        'MYSQLD_USER' => "env",
        'MYSQLD_PASSWORD' => "env",
      }
    end
  end

  describe "PostgreSQL" do
    let(:adapter) { 'postgresql' }

    describe "with ElephantSQL addon" do
      it_should_behave_like "a database", {
        'RAILS_ENV' => "production",
        'ELEPHANTSQL_URL' => 'postgres://env:env@env.env.env:42/env',
      }
    end
  end
end
