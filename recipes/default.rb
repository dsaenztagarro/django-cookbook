#
# Cookbook Name:: django-cirujanos
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "my-environment"

mercurial "/home/vagrant/Development/projects/django-cirujanos" do
  repository "ssh://hg@bitbucket.org/dsaenztagarro/cirujanos"
  reference "tip"
  action :sync
end

include_recipe "my-environment::permissions"

# Backend

include_recipe "apache2"
include_recipe "apache2::mod_wsgi"

# disable iptables for now
include_recipe "iptables::disabled"

# kill default site
apache_site "default" do
  enable false
end

include_recipe "python"
include_recipe "mercurial"

node.set['mysql']['server_root_password'] = 'root'
include_recipe "mysql::server"

mysql_connection_info = {
  :host     => 'localhost',
  :port     => node['mysql']['port'],
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database 'cirujanos_development' do
  connection mysql_connection_info
  action :create
end

mysql_database 'cirujanos_test' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'create_user_development' do
  connection    mysql_connection_info
  password      'development'
  database_name 'cirujanos_development'
  host          '%'
  privileges    [:all]
  action        :grant
end

mysql_database_user 'create_user_test' do
  connection    mysql_connection_info
  password      'development'
  database_name 'cirujanos_test'
  host          '%'
  privileges    [:all]
  action        :grant
end
