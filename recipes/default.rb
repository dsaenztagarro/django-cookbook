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
