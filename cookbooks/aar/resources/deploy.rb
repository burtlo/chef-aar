actions :install

default_action :install

attribute :download_url, :kind_of => String, :name_attribute => true
attribute :path, :kind_of => String
attribute :user, :kind_of => String
attribute :group, :kind_of => String
