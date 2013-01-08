#cctrl_database_configuration

Override empty database.yml settings with the ENV vars on the cloudControl plattform. Supports [MySQLs](https://www.cloudcontrol.com/add-ons/mysqls "MySQLs Addon at cloudControl"), [MySQLd](https://www.cloudcontrol.com/add-ons/mysqld "MySQLd Addon at cloudControl") and [ElephantSQL](https://www.cloudcontrol.com/add-ons/elephantsql "ElephantSQL Addon at cloudControl") (Postgres)

##Installation

Add the following to your gemfile 
~~~
gem "cloudcontrol", :git => "git://github.com/Traxmaxx/cctrl_database_configuration.git"
~~~

And run `bundle install`

Now modify or create your `database.yml` and leave the credentials empty. You can override everything anytime by just adding them again.

To share a database over two deployments without hardcoding the credentials you need to add them with the [Custom Config Addon](https://www.cloudcontrol.com/add-ons/config "Custom Config Addon at cloudControl")

##Example database.yml

Credentials will be served through the gem:
~~~
production:
  host:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database:
  pool: 5
  username:
  password:
~~~

Credentials will not be touched because they are not empty:
~~~
production:
  host: localhost
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: db_name
  pool: 5
  username: username
  password: password
~~~

You can also serve specific values only through the gem:
~~~
production:
  host: localhost
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: db_name
  pool: 5
  username:
  password:
~~~