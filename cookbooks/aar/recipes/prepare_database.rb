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
  command "mysql -e \"CREATE USER 'aarapp'@'localhost' IDENTIFIED BY '#{node['aar']['database_password']}'\""
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
