#
# Cookbook Name:: family
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Database

node.set['mysql']['server_root_password'] = 'root'

# include_recipe "mysql::server"
# include_recipe "mysql::client"

include_recipe 'database'
include_recipe 'database::mysql'

mysql_connection_info = {
  :host     => 'localhost',
  :port     => node['mysql']['port'].to_i,
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database 'family_development' do
  connection mysql_connection_info
  action :create
end

mysql_database 'family_test' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'development' do
  connection    mysql_connection_info
  password      'development'
  database_name 'family_development'
  host          '%'
  privileges    [:all]
  action        :grant
end

mysql_database_user 'development' do
  connection    mysql_connection_info
  password      'development'
  database_name 'family_test'
  host          '%'
  privileges    [:all]
  action        :grant
end


# Backend

node.default['nodejs']['version'] = '0.10.28'
include_recipe 'nodejs'

execute "install_global_modules" do
  command <<-EOH
    npm install -g bower
  EOH
end
