#
# The archive is downloaded and the only thing controlling the idempotence is if
# the left over archive is present in the temp directory. This is not especially
# telling about the state of the application. Ideally, I would be able to say
# don't download this when "the software is already deployed"
#
# ISSUE: Not a good measure of guard criteria
#
execute "wget #{node['aar']['download_url']} -O /tmp/master.zip" do
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
execute "mv /tmp/Awesome-Appliance-Repair-master/AAR #{node['aar']['install_path']}" do
  only_if { ::File.exist?("/tmp/Awesome-Appliance-Repair-master/AAR") }
  not_if { ::File.exist?(node['aar']['install_path']) }
end

execute "chown -R www-data:www-data #{node['aar']['install_path']}" do
  not_if { user_owns_path?("www-data",node['aar']['install_path']) }
end
