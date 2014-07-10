# See http://docs.opscode.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "franklinwebber"
client_key               "#{current_dir}/franklinwebber.pem"
validation_client_name   "franklinwebber-validator"
validation_key           "#{current_dir}/franklinwebber-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/franklinwebber"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:editor] = "subl -w"
