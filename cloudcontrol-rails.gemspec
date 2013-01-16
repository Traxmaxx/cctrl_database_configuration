# encoding = utf-8

Gem::Specification.new do |s|
  s.name          = 'cloudcontrol-rails'
  s.version       = "0.0.5"
  s.authors       = ["Alexander Rösel", "Ivan Kusalic"]
  s.email         = ["info@netzok.net"]
  s.summary       = "Autoload MySQL and Postgres credentials from ENV vars on cloudControl"
  s.description   = "Use credentials set in ENV vars if database.yml credentials are empty. Supports MySQL and ElephantSQL (Postgres) on the cloudControl platform."
  s.homepage      = "https://github.com/Traxmaxx/cctrl_database_configuration"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
