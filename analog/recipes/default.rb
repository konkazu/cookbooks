#
# Cookbook Name:: analog
# Recipe:: default
#
# Copyright 2012, ryuzee 
#
# MIT License 
#
case node[:platform]
when "centos"
  # install epel
  e = execute "wget -O /tmp/analog-6.0.4-1.el5.i386.rpm http://www.iddl.vt.edu/~jackie/analog/analog-6.0.4-1.el5.i386.rpm" do
    action :run
  end
  package "analog" do
    action :install
    source "/tmp/analog-6.0.4-1.el5.i386.rpm"
    provider Chef::Provider::Package::Rpm
  end
end
