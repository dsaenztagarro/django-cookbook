mkdir -p /root/.ssh
cp /vagrant/conf/id_rsa.pub /home/vagrant/.ssh/authorized_keys
cp /vagrant/conf/known_hosts /home/vagrant/.ssh/known_hosts
cp /vagrant/conf/id_rsa.pub /root/.ssh/authorized_keys
cp /vagrant/conf/known_hosts /root/.ssh/known_hosts
/etc/init.d/ssh restart
