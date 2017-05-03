# add-hosts-to-puppet-foreman
Script for adding an already existing Centos7 host to Foreman-Puppet, i am sure this can be changed 
to any other distro.

#How to use it 

on puppet master node (Which in my case is also where Foreman is also installed)

Run these commands

#puppet cert sign --all
#systemctl restart puppet
#systemctl restart foreman-proxy
#systemctl restart foreman


