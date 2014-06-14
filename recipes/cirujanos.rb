mercurial "/home/vagrant/Development/projects/cirujanos" do
  repository "ssh://hg@bitbucket.org/dsaenztagarro/cirujanos"
  reference "tip"
  key "/home/vagrant/.ssh/id_rsa"
  action :clone
end

include_recipe "my-environment::permissions"

# Apache server folders

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


# Database

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
