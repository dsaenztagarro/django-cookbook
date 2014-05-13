#
# Cookbook Name:: django-cirujanos
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe "apt"
include_recipe "apache2"
include_recipe "apache2::mod_wsgi"

include_recipe "mysql::server"

# disable iptables for now
include_recipe "iptables::disabled"

#kill default site
apache_site "default" do
  enable false
end
