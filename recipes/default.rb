#
# Cookbook Name:: django
# Recipe:: default
#
# Copyright (C) 2014 David Sáenz Tagarro
#
# All rights reserved - Do Not Redistribute
#

# Environment

# Added pip settings
cookbook_file 'copy_bashrc' do
  path '/home/vagrant/.bashrc'
  source 'bashrc'
  owner 'vagrant'
  group 'vagrant'
  action :create
end

include_recipe "my-environment"

include_recipe "mercurial"

mercurial "/home/vagrant/Development/projects/cirujanos" do
  repository "ssh://hg@bitbucket.org/dsaenztagarro/cirujanos"
  reference "tip"
  key "/home/vagrant/.ssh/id_rsa"
  action :clone
end

include_recipe "my-environment::permissions"

directory "/var/www/cirujanos" do
  owner 'vagrant'
  group 'vagrant'
  recursive true
end

directory "/var/www/cirujanos/static" do
  owner 'www-data'
  group 'www-data'
  recursive true
end

directory "/var/www/cirujanos/media" do
  owner 'www-data'
  group 'www-data'
  recursive true
end

execute "create_virtualenv" do
  cwd "/var/www/cirujanos"
  command <<-EOH
    virtualenv env
    chown www-data:www-data -R /var/www/cirujanos/env
  EOH
end

execute "pip_install_requirements" do
  cwd "/var/www/cirujanos"
  command <<-EOH
    source env/bin/activate
    pip install -r /home/vagrant/Development/projects/cirujanos/requirements.txt
  EOH
end

execute "install_python_dev" do
  command <<-EOH
    apt-get install python-setuptools python-dev build-essential -y
    apt-get install libmysqlclient-dev -y
    apt-get install python-mysqldb -y
    apt-get install gettext -y
    apt-get install coffeescript -y
  EOH
end

# Database

node.set['mysql']['server_root_password'] = 'root'

include_recipe "mysql::server"
include_recipe "mysql::client"

include_recipe 'database'
include_recipe 'database::mysql'

mysql_connection_info = {
  :host     => 'localhost',
  :port     => node['mysql']['port'].to_i,
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

mysql_database_user 'development' do
  connection    mysql_connection_info
  password      'development'
  database_name 'cirujanos_development'
  host          '%'
  privileges    [:all]
  action        :grant
end

mysql_database_user 'development' do
  connection    mysql_connection_info
  password      'development'
  database_name 'cirujanos_test'
  host          '%'
  privileges    [:all]
  action        :grant
end

# Backend

include_recipe "apache2"
include_recipe "apache2::mod_wsgi"
include_recipe "apache2::mod_xsendfile"

# disable iptables for now
include_recipe "iptables::disabled"

# kill default site
apache_site "default" do
  enable false
end

include_recipe "python"
