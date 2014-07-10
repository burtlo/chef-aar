actions :install

default_action :install

attribute :path, :kind_of => String, :name_attribute => true
attribute :user, :kind_of => String
attribute :password, :kind_of => String
attribute :database, :kind_of => String