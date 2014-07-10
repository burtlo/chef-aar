#
# Cookbook Name:: aar
# Recipe:: default
#
# Copyright 2014
#

include_recipe "apt::default"

package "apache2"
package "mysql-client"
package "mysql-server"
package "unzip"
package "libapache2-mod-wsgi"
package "python-pip"
package "python-mysqldb"

python_pip "flask"

service "apache2" do
  action [ :enable, :start ]
end

service "mysql" do
  action [ :enable, :start ]
end

include_recipe "#{cookbook_name}::download_and_deploy"
include_recipe "#{cookbook_name}::configure_apache"
include_recipe "#{cookbook_name}::configure_aar"
include_recipe "#{cookbook_name}::prepare_database"