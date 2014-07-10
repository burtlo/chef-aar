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

aar_deploy node['aar']['download_url'] do
  path node['aar']['install_path']
  user node['aar']['user']
  group node['aar']['group']
end

include_recipe "#{cookbook_name}::configure_apache"

aar_configuration node['aar']['install_path'] do
  database_name node['aar']['database']['name']
  database_user node['aar']['database']['user']
  database_password node['aar']['database']['password']
  secret_key node['aar']['secret_key']
  user node['aar']['user']
  group node['aar']['group']
  server_admin_email node['aar']['server_admin_email']
  notifies :restart, "service[apache2]"
end
