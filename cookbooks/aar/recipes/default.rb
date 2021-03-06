#
# Cookbook Name:: aar
# Recipe:: default
#
# Copyright 2014
#

package "apache2"

service "apache2" do
  action [ :enable, :start ]
end

#
# I noticed on the Digital Ocean machines I provisioned an error when
# attempting to install the mysql-client and mysql-server. Particularlly
# package instruction wanted a much higher version than then one I found
# being offered when I attempted to install manually.
#
# ISSUE: Not Idempotent
#
execute "apt-get update"

package "mysql-client"
package "mysql-server"

service "mysql" do
  action [ :enable, :start ]
end

package "unzip"

#
# The archive is downloaded and the only thing controlling the idempotence is if
# the left over archive is present in the temp directory. This is not especially
# telling about the state of the application. Ideally, I would be able to say
# don't download this when "the software is already deployed"
#
# ISSUE: Not a good measure of guard criteria
#
execute "wget https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip -O /tmp/master.zip" do
  not_if { ::File.exist?("/tmp/master.zip") }
end

#
# I don't especially enjoy having all these paths repeated here. If I were to
# change the url above this line could break without me knowing it.
#
# ISSUE: Magic Strings, Repitition, Brittle
#
execute "unzip /tmp/master.zip -d /tmp" do
  not_if { ::File.exist?("/tmp/Awesome-Appliance-Repair-master") }
end

#
# ISSUE: Magic Strings, Repitition, Brittle
#
execute "mv /tmp/Awesome-Appliance-Repair-master/AAR /var/www" do
  only_if { ::File.exist?("/tmp/Awesome-Appliance-Repair-master/AAR") }
  not_if { ::File.exist?("/var/www/AAR") }
end


#
# ISSUE: Not Idempotent
#
execute "chown -R www-data:www-data /var/www/AAR"

package "libapache2-mod-wsgi"
package "python-pip"
package "python-mysqldb"

#
# ISSUE: Not Idempotent
#
execute "pip install flask"

#
# ISSUE: Not Idempotent
#
execute "apachectl stop"

#
# This was copied directly from the existing script which found all the folders
# within that sites-enabled and disabled them. I moved it here but ultimately
# this is some really ugly code that is so complex looking that it makes it
# a terrible thing to maintain in the future.
#
# ISSUE: Ugly
#
directories = Dir["/etc/apache2/sites-enabled/*"].find_all { |name| File.symlink?(name) }

directories.each do |name|

  file name do
    action :delete
    notifies :restart, "service[apache2]"
  end

end

install_directory = "/var/www/AAR"

template "/etc/apache2/sites-enabled/AAR-apache.conf" do
  source "apache.conf.erb"
  variables :directory => install_directory
end

#
# Having the database password and the secret key here in the recipe is a bad
# idea. These values in the original script were being generated from some
# python code. A similar Ruby tool could be employed to generate the scripts
#
# These values should be generated and then added to the node so that they
# are available after node save.
#
# ISSUE: Security
#
app_database_password = "app_database_password"
secret_key = "secret_key"

template "#{install_directory}/AAR_config.py" do
  source "AAR_config.py.erb"
  variables :app_database_password => app_database_password,
    :secret_key => secret_key

end


#
# This is a powerful concept that I did not understand when I first started
# working with Chef. All the previous examples showed me sending notifications
# to services. It is powerful being able to domino events like this with
# notifications.
#

execute "Prepare Database" do
  command "mysql < /tmp/Awesome-Appliance-Repair-master/make_AARdb.sql"
  action :nothing
end

execute "Create Database User" do
  command "mysql -e \"CREATE USER 'aarapp'@'localhost' IDENTIFIED BY '#{app_database_password}'\""
  action :nothing
end

execute "Grant User Privileges" do
  command "mysql -e \"GRANT CREATE,INSERT,DELETE,UPDATE,SELECT on AARdb.* to 'aarapp'@'localhost'\""
  action :nothing
end

file "Database Script Run Complete" do
  path "/var/www/AAR/database_prepared"
  action :create_if_missing
  notifies :run, "execute[Prepare Database]"
  notifies :run, "execute[Create Database User]"
  notifies :run, "execute[Grant User Privileges]"
end


#
# ISSUE: Not Idempotent
#
execute "apachectl graceful"