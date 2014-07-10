actions :install

default_action :install

attribute :path, :kind_of => String, :name_attribute => true
attribute :secret_key, :kind_of => String
attribute :user, :kind_of => String
attribute :group, :kind_of => String

attribute :database_name, :kind_of => String
attribute :database_user, :kind_of => String
attribute :database_password, :kind_of => String

# TODO: Validations that it is in fact an email
attribute :server_admin_email, :kind_of => String