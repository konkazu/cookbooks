#
# Cookbook Name:: dns
# Recipe:: default
#
# Copyright 2013, ryuzee
#
# MIT License 
#
case node[:platform]
when "centos"
  template "/etc/resolv.conf" do
    source "resolv.conf.erb"
    owner "root"
    group "root"
    mode "0644"
  end
end

# vim: filetype=ruby.chef
