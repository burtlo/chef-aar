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
template "#{node['aar']['install_path']}/AAR_config.py" do
  source "AAR_config.py.erb"
  variables :app_database_password => node['aar']['database_password'],
    :secret_key => node['aar']['secret_key']

end
