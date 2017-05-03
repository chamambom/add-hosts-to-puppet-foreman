PUPPETMASTER="puppet.district10.example.com"

# start with a subscribed RHEL7 box

rpm -Uvh https://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm

rpm -Uvh https://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-22.0-2.noarch.rpm

#rpm -Uvh http://mirror3.mirror.garr.it/mirrors/scientific/7x/x86_64/os/Packages/yum-utils-1.1.31-40.el7.noarch.rpm

#Below line is mostly used when you are on RHEL7
#yum-config-manager --enable rhel-7-server-optional-rpms

yum clean all
#install dependent packages

yum install -y augeas puppet git policycoreutils-python

# Set PuppetServer
augtool -s set /files/etc/puppet/puppet.conf/agent/server $PUPPETMASTER

# Set Environment
augtool -s set /files/etc/puppet/puppet.conf/agent/environment production

# Set ca cert
augtool -s set /files/etc/puppet/puppet.conf/agent/ca_server $PUPPETMASTER

# Set cert name
augtool -s set /files/etc/puppet/puppet.conf/agent/certname `hostname -f`

# Puppet Plugins
augtool -s set /files/etc/puppet/puppet.conf/main/pluginsync true

# Allow puppetrun from foreman/puppet master to work
augtool -s set /files/etc/puppet/puppet.conf/main/listen true

# Allow execution of puppetrun button from puppet master
num=$(awk 'END { print NR }' /etc/puppet/auth.conf)
lunum=`expr $num - 4`
sed -i "$lunum i\ \n#added to allow execution of puppetrun button\npath /run\nauth any\nmethod save\nallow $PUPPETMASTER\n" /etc/puppet/auth.conf
# for older versions of puppet, also need to "touch /etc/puppet/namespace.auth"

# check in to foreman
puppet agent --test
sleep 1
puppet agent --test

systemctl start puppet
systemctl enable puppet