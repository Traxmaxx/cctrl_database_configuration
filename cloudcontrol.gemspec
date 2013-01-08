Gem::Specification.new do |s|
  s.name        = 'cloudcontrol'
  s.version     = '0.0.1'
  s.date        = '2013-01-08'
  s.summary     = "Autoload MySQL and Postgres credentials from ENV vars on cloudControl"
  s.description = "Use credentials set in ENV vars if database.yml credentials are empty. Supports MySQL and ElephantSQL (Postgres) on the cloudControl platform."
  s.authors     = ["Alexander Rösel"]
  s.email       = 'info@netzok.net'
  s.files       = ["lib/cloudcontrol.rb", "LICENSE"]
  s.homepage    = 'http://justfrontend.com'
end