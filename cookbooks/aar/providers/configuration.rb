
use_inline_resources

action :install do
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
  install_path = "#{new_resource.path}/Awesome-Appliance-Repair-master/AAR"

  template "#{install_path}/AAR_config.py" do
    source "AAR_config.py.erb"
    variables :user => new_resource.database_user,
      :password => new_resource.database_password,
      :database => new_resource.database_name,
      :secret_key => new_resource.secret_key
  end

  template "#{install_path}/awesomeapp.wsgi" do
    source "awesomeapp.wsgi.erb"
    variables :install_path => install_path
  end

  template "/etc/apache2/sites-enabled/AAR-apache.conf" do
    source "apache.conf.erb"
    variables :install_path => install_path,
      :user => new_resource.user,
      :group => new_resource.group,
      :server_admin_email => new_resource.server_admin_email
  end

  aar_database new_resource.path do
    database new_resource.database_name
    user     new_resource.database_user
    password new_resource.database_password
  end

end
