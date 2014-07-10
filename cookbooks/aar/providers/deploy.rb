
use_inline_resources

action :install do

  #
  # The archive is downloaded and the only thing controlling the idempotence is if
  # the left over archive is present in the temp directory. This is not especially
  # telling about the state of the application. Ideally, I would be able to say
  # don't download this when "the software is already deployed"
  #

  archive_download_location = "/tmp/master.zip"
  install_path = new_resource.path

  execute "wget #{new_resource.download_url} -O #{archive_download_location}" do
    not_if { ::File.exist?(archive_download_location) }
  end

  execute "unzip #{archive_download_location} -d #{install_path}" do
    only_if { ::File.exist?(archive_download_location) }
    not_if { ::File.exist?("#{install_path}/Awesome-Appliance-Repair-master") }
  end

  execute "chown -R #{new_resource.user}:#{new_resource.group} #{install_path}" do
    not_if { user_owns_path?("www-data",install_path) }
  end

end