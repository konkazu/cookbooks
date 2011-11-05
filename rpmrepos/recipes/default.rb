#
# Cookbook Name:: rpmrepos
# Recipe:: default
#
# Copyright 2011, ryuzee 
#
# MIT License 
#
case node[:platform]
when "centos"
  # install epel
  e = execute "wget -O /tmp/epel-release-5-4.noarch.rpm http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm" do
    action :run
  end
  package "epel" do
    action :install
    source "/tmp/epel-release-5-4.noarch.rpm"
    provider Chef::Provider::Package::Rpm
  end

  # install remi 
  e = execute "wget -O /tmp/remi-release-5.rpm http://rpms.famillecollet.com/enterprise/remi-release-5.rpm" do
    action :run
  end
  package "remi" do
    action :install
    source "/tmp/remi-release-5.rpm"
    provider Chef::Provider::Package::Rpm
  end

else
end


