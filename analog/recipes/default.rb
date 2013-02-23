#
# Cookbook Name:: analog
# Recipe:: default
#
# Copyright 2013, ryuzee 
#
# MIT License 
#
case node[:platform]
when "centos", "amazon"
  f = "analog-6.0.4-1.x86_64.rpm"
  if node[:platform] == "centos" then
    if node[:platform_version] >= "6.0" then 
      f = "analog-6.0.4-1.x86_64.rpm"
    elsif node[:platform_version] >= "5.0" then 
      f = "analog-6.0.4-1.el5.i386.rpm"
    end
  end
  e = execute "wget -O /tmp/#{f} http://www.iddl.vt.edu/~jackie/analog/#{f}" do
    action :run
  end

  package "analog" do
    action :install
    source "/tmp/#{f}"
    provider Chef::Provider::Package::Rpm
  end
end

# vim: filetype=ruby.chef
