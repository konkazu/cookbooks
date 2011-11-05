#
# Cookbook Name:: dns
# Recipe:: default
#
# Copyright 2011, ryuzee
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
else
end
